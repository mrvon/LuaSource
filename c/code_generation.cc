#include "llvm/ADT/STLExtras.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Verifier.h"
#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <map>
#include <memory>
#include <string>
#include <vector>

namespace llvm {
    // Cloning make_unique here until it's standard in C++14.
    // Using a namespace to avoid conflicting with MSVC's std::make_unique (which
    // ADL can sometimes find in unqualified calls).
    template <class T, class... Args>
        static
        typename std::enable_if<!std::is_array<T>::value, std::unique_ptr<T>>::type
        make_unique(Args &&... args) {
            return std::unique_ptr<T>(new T(std::forward<Args>(args)...));
        }
}

// ---------------------------------------------------------------------------//
// Lexer
// ---------------------------------------------------------------------------//

// The Lexer returns tokes [0-255] if it is an unknown character, otherwise one
// of these for known things.
enum Token {
    tok_eof = -1,

    // commands
    tok_def = -2,
    tok_extern = -3,

    // primary
    tok_identifier = -4,
    tok_number = -5,
};

static std::string IdentifierStr;   // Filled in if tok_identifier
static double NumVal;               // Filled in if tok_number

// gettok - Return the next token from standard input.
static int gettok() {
    static int LastChar = ' ';

    // Skip any whitespace.
    while (isspace(LastChar)) {
        LastChar = getchar();
    }

    if (isalpha(LastChar)) { // identifier: [a-zA-Z][a-zA-Z0-9]*
        IdentifierStr = LastChar;

        while (isalnum(LastChar = getchar())) {
            IdentifierStr += LastChar;
        }

        if (IdentifierStr == "def") {
            return tok_def;
        }
        if (IdentifierStr == "extern") {
            return tok_extern;
        }

        return tok_identifier;
    }

    if (isdigit(LastChar) || LastChar == '.') { // Number: [0-9.]+
        std::string NumStr;

        do {
            NumStr += LastChar;
            LastChar = getchar();
        } while (isdigit(LastChar) || LastChar == '.');

        NumVal = strtod(NumStr.c_str(), 0);
        return tok_number;
    }

    if (LastChar == '#') {
        // Comment until end of line.
        do {
            LastChar = getchar();
        } while (LastChar != EOF && LastChar != '\n' && LastChar != '\r');

        if (LastChar != EOF) {
            return gettok();
        }
    }

    // Check for end of file, Don't eat the EOF.
    if (LastChar == EOF) {
        return tok_eof;
    }

    // Otherwise, just return the character as its ascii value.
    int ThisChar = LastChar;
    LastChar = getchar();
    return ThisChar;
}

static std::unique_ptr<Module> *TheModule;
static IRBuilder<> Builder(getGlobalContext());
static std::map<std::string, Value*> NamedValues;


/// ExprAST - Base class for all expression nodes.
class ExprAST {
public:
    virtual ~ExprAST() {}
    virtual Value *codegen() = 0;
};

/// NumberExprAST - Expression class for numeric literals like "1.0"
class NumberExprAST : public ExprAST {
public:
    NumberExprAST(double Val) : Val(Val) {}
    virtual Value *codegen() {
    }
private:
    double Val;
};

/// VariableExprAST - Expression class for referencing a variable, like "a".
class VariableExprAST : public ExprAST {
public:
    VariableExprAST(const std::string &Name) : Name(Name) {}
private:
    std::string Name;
};

/// BinaryExprAST - Expression class for a binary operator.
class BinaryExprAST : public ExprAST {
public:
    BinaryExprAST(char op, std::unique_ptr<ExprAST> LHS,
            std::unique_ptr<ExprAST> RHS)
        : Op(op), LHS(std::move(LHS)), RHS(std::move(RHS)) {}
private:
    char Op;
    std::unique_ptr<ExprAST> LHS, RHS;
};

/// CallExprAST - Expression class for function calls.
class CallExprAST : public ExprAST {
public:
    CallExprAST(const std::string &Callee,
            std::vector<std::unique_ptr<ExprAST>> Args)
        : Callee(Callee), Args(std::move(Args)) {}
private:
    std::string Callee;
    std::vector<std::unique_ptr<ExprAST>> Args;
};

/// PrototypeAST - This class represents the "prototype" for a function,
/// which captures its name, and its argument names (thus implicitly the number
/// of arguments the function takes).
class PrototypeAST {
public:
    PrototypeAST(const std::string &Name, std::vector<std::string> Args)
        : Name(Name), Args(std::move(Args)) {}
private:
    std::string Name;
    std::vector<std::string> Args;
};

/// FunctionAST - This class represents a function definition itself.
class FunctionAST {
public:
    FunctionAST(std::unique_ptr<PrototypeAST> Proto,
            std::unique_ptr<ExprAST> Body)
        : Proto(std::move(Proto)), Body(std::move(Body)) {}
private:
    std::unique_ptr<PrototypeAST> Proto;
    std::unique_ptr<ExprAST> Body;
};

// ---------------------------------------------------------------------------//
// Parser
// ---------------------------------------------------------------------------//

/// CurTok/getNextToken - Provice a simple token buffer. CurTok is the current
/// token the parser is looking at. getNextToken reads another token from the
/// lexer and updates CurTok with its results.
static int CurTok;
static int getNextToken() {
    return CurTok = gettok();
}

/// Error* - These are litter helper functions for error handling.
std::unique_ptr<ExprAST> Error(const char *Str) {
    fprintf(stderr, "Error: %s\n", Str);
    return nullptr;
}

std::unique_ptr<PrototypeAST> ErrorP(const char *Str) {
    Error(Str);
    return nullptr;
}

Value *ErrorV(const char *Str) {
    Error(Str);
    return nullptr;
}

/// numberexpr ::= number
static std::unique_ptr<ExprAST> ParseNumberExpr() {
    auto Result = llvm::make_unique<NumberExprAST>(NumVal);
    getNextToken(); // consume the number
    return std::move(Result);
}

static std::unique_ptr<ExprAST> ParseExpression();

/// parenexpr ::= '(' expression ')'
static std::unique_ptr<ExprAST> ParseParenExpr() {
    getNextToken(); // eat (.
    auto V = ParseExpression();
    if (!V) {
        return nullptr;
    }

    if (CurTok != ')') {
        return Error("expected ')'");
    }
    getNextToken(); // eat ).
    return V;
}

/// identifierexpr
///     ::= identifier                          variable reference
///     ::= identifier '(' expression* ')'      function call
static std::unique_ptr<ExprAST> ParseIdentifierExpr() {
    std::string IdName = IdentifierStr;

    getNextToken(); // eat identifier.

    if (CurTok != '(') { // Simple variable ref.
        return llvm::make_unique<VariableExprAST>(IdName);
    }

    // Call.
    getNextToken(); // eat (
    std::vector<std::unique_ptr<ExprAST>> Args;
    if (CurTok != ')') {
        while (1) {
            if (auto Arg = ParseExpression()) {
                Args.push_back(std::move(Arg));
            }
            else {
                return nullptr;
            }

            if (CurTok == ')') {
                break;
            }

            if (CurTok != ',') {
                return Error("Expected ')' or ',' in argument list");
            }

            getNextToken();
        }
    }

    // Eat the ')'.
    getNextToken();

    return llvm::make_unique<CallExprAST>(IdName, std::move(Args));
}

/// primary
///     ::= identifierexpr
///     ::= numberexpr
///     ::= parenexpr
static std::unique_ptr<ExprAST> ParsePrimary() {
    switch(CurTok) {
    case tok_identifier:
        return ParseIdentifierExpr();
    case tok_number:
        return ParseNumberExpr();
    case '(':
        return ParseParenExpr();
    default:
        return Error("unknown token when expecting an expression");
    }
}

/// BinopPrecedence - This holds the precedence for each binary operator that is
/// defined.
static std::map<char, int> BinopPrecedence;

/// GetTokPrecedence - Get the precedence of the pending binary operator token.
static int GetTokPrecedence() {
    if (!isascii(CurTok)) {
        return -1;
    }

    // Make sure it's a declared binop.
    int TokPrec = BinopPrecedence[CurTok];
    if (TokPrec <= 0) {
        return -1;
    }
    return TokPrec;
}

/// binoprhs
///     ::= ('+' primary)*
static std::unique_ptr<ExprAST> ParseBinOpRHS(int ExprPrec,
        std::unique_ptr<ExprAST> LHS) {
    // If this is a binop, find its precedence.
    while (1) {
        int TokPrec = GetTokPrecedence();

        // If this is a binop that binds at least as tightly as the current binop,
        // consume it, otherwise we are done.
        if (TokPrec < ExprPrec) {
            return LHS;
        }

        // Okay, we know this is a binop.
        int BinOp = CurTok;
        getNextToken(); // eat binop

        // Parse the primary expression after the binary operator.
        auto RHS = ParsePrimary();
        if (!RHS) {
            return nullptr;
        }

        // If BinOp binds less tightly with RHS than the operator after RHS, let
        // the pending operator take RHS as its LHS.
        int NextPrec = GetTokPrecedence();
        if (TokPrec < NextPrec) {
            RHS = ParseBinOpRHS(TokPrec+1, std::move(RHS));
            if (!RHS) {
                return nullptr;
            }
        }

        // Merge LHS/RHS
        LHS = llvm::make_unique<BinaryExprAST>(BinOp, std::move(LHS),
                std::move(RHS));
    }
}

/// expression
///     ::= primary binoprhs
static std::unique_ptr<ExprAST> ParseExpression() {
    auto LHS = ParsePrimary();
    if (!LHS) {
        return nullptr;
    }
    return ParseBinOpRHS(0, std::move(LHS));
}

/// prototype
///     ::= id '(' id* ')'
static std::unique_ptr<PrototypeAST> ParsePrototype() {
    if (CurTok != tok_identifier) {
        return ErrorP("Expected function name in prototype");
    }

    std::string FnName = IdentifierStr;

    getNextToken();

    if (CurTok != '(') {
        return ErrorP("Expected '(' in prototype");
    }

    // Read the list of argument names.
    std::vector<std::string> ArgNames;
    while (getNextToken() == tok_identifier) {
        ArgNames.push_back(IdentifierStr);
    }

    if (CurTok != ')') {
        return ErrorP("Expected ')' in prototype");
    }

    // success
    getNextToken(); // eat ')'.

    return llvm::make_unique<PrototypeAST>(FnName, std::move(ArgNames));
}

/// definition ::= 'def' prototype expression
static std::unique_ptr<FunctionAST> ParseDefinition() {
    getNextToken(); // eat def.

    auto Proto = ParsePrototype();
    if (!Proto) {
        return nullptr;
    }

    if (auto E = ParseExpression()) {
        return llvm::make_unique<FunctionAST>(std::move(Proto), std::move(E));
    }

    return nullptr;
}

/// external ::= 'extern' prototype
static std::unique_ptr<PrototypeAST> ParseExtern() {
    getNextToken(); // eat extern.
    return ParsePrototype();
}

/// toplevelexpr ::= expression
static std::unique_ptr<FunctionAST> ParseTopLevelExpr() {
    if (auto E = ParseExpression()) {
        // Make an anonymous proto.
        auto Proto = llvm::make_unique<PrototypeAST>("", std::vector<std::string>());
        return llvm::make_unique<FunctionAST>(std::move(Proto), std::move(E));
    }
    return nullptr;
}

// ---------------------------------------------------------------------------//
// Top-Level parsing
// ---------------------------------------------------------------------------//

static void HandleDefinition() {
    if (ParseDefinition()) {
        fprintf(stderr, "Parsed a function definition.\n");
    } else {
        // Skip token for error recovery.
        getNextToken();
    }
}

static void HandleExtern() {
    if (ParseExtern()) {
        fprintf(stderr, "Parsed an extern\n");
    } else {
        // Skip token for error recovery.
        getNextToken();
    }
}

static void HandleTopLevelExpression() {
    // Evaluate a top-level expresion into a anonymous function.
    if (ParseTopLevelExpr()) {
        fprintf(stderr, "Parsed a top-level expr\n");
    } else {
        // Skip token for error recovery.
        getNextToken();
    }
}

/// top ::= definition | external | expression | ';'
static void MailLoop() {
    while (1) {
        fprintf(stderr, "ready> ");
        switch (CurTok) {
            case tok_eof:
                return;
            case ';': // ignore top-level semicolons.
                getNextToken();
                break;
            case tok_def:
                HandleDefinition();
                break;
            case tok_extern:
                HandleExtern();
                break;
            default:
                HandleTopLevelExpression();
                break;
        }
    }
}

int main(int argc, char const* argv[]) {
    // Install standard binary operators.
    // 1 is lowest precedence.
    BinopPrecedence['<'] = 10;
    BinopPrecedence['+'] = 20;
    BinopPrecedence['-'] = 20;
    BinopPrecedence['*'] = 40; // highest.

    // Prime the first token.
    fprintf(stderr, "ready> ");
    getNextToken();

    // Run the main "interpreter loop" now.
    MailLoop();

    return 0;
}
