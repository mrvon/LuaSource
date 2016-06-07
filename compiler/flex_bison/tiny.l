%option noyywrap

%{
/* Lex program for tiny language */
#include <stdio.h>
#include <stdbool.h>

enum {
    ERROR,
    IF,
    THEN,
    ELSE,
    END,
    REPEAT,
    UNTIL,
    READ,
    WRITE,
    ASSIGN,
    EQ,
    LT,
    PLUS,
    MINUS,
    TIMES,
    OVER,
    LPAREN,
    RPAREN,
    SEMI,
    NUM,
    ID,
};
%}

digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}+
newline     \n
whitespace  [ \t]+

%%

"if"            { return IF; }
"then"          { return THEN; }
"else"          { return ELSE; }
"end"           { return END; }
"repeat"        { return REPEAT; }
"until"         { return UNTIL; }
"read"          { return READ; }
"write"         { return WRITE; }
":="            { return ASSIGN; }
"="             { return EQ; }
"<"             { return LT; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return TIMES; }
"/"             { return OVER; }
"("             { return LPAREN; }
")"             { return RPAREN; }
";"             { return SEMI; }
{number}        { return NUM; }
{identifier}    { return ID; }
{whitespace}    { /* skip whitespace */ }
"{"             {
    char c;
    do {
        c = input();
    } while (c != '}');
}
.               { return ERROR; }
<<EOF>>         { return EOF; }


%%

int main() {
    while (true) {
        int token = yylex();
        if (token == EOF) {
            break;
        }

        fprintf(yyout, "TOKEN (%d)%s ", token, yytext);
    }
    return 0;
}
