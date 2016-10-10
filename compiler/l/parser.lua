--[[
TINY language EBNF

program        -> stmt-sequence
stmt-sequence  -> statement { ; statement }
statement      -> if-stmt | repeat-stmt | assign-stmt | read-stmt | write-stmt
if-stmt        -> if exp then stmt-sequence [ else stmt-sequence ] end
repeat-stmt    -> repeat stmt-sequence until exp
assign-stmt    -> identifier := exp
read-stmt      -> read identifier
write-stmt     -> write exp
exp            -> simple-exp [ comparision-op simple-exp ]
comparision-op -> < | =
simple-exp     -> term { addop term }
addop          -> + | -
term           -> factor { mulop factor }
mulop          -> * | /
factor         -> ( exp ) | number | identifier
]]

local Scanner = require "scanner"
local Inspect = require "inspect"

local TokenType = Scanner.TokenType

-- *curr_token* always return the same table instance
local curr_token = Scanner.curr_token
local next_token = Scanner.next_token
local token_name = Scanner.token_name

local NodeKind = {
    STATEMENT = 1,
    EXP       = 2,
}

local StatementKind = {
    IF     = 1,
    REPEAT = 2,
    ASSIGN = 3,
    READ   = 4,
    WRITE  = 5,
}

local ExpKind = {
    OP      = 1,
    CONST   = 2,
    ID      = 3,
}


local function syntax_error(...)
    print(...)
    print("syntax error.")
    print(debug.traceback())
end

local function match(expected)
    local token = curr_token()

    if token.id == expected then
        next_token()
    else
        syntax_error("unexpected token ->", token_name(token.id), token.str, 
        "expected token ->", token_name(expected))
    end
end

local function new_stmt_node(kind, attr_str)
    return {
        node_kind = NodeKind.STATEMENT,
        kind = kind,
        attr_str = attr_str,
        child = {},
    }
end

local function new_exp_node(kind, attr_id, attr_str)
    return {
        node_kind = NodeKind.EXP,
        kind = kind,
        attr_id = attr_id,
        attr_str = attr_str,
        child = {},
        -- lineno
        -- type = Void
    }
end

local stmt_sequence
local statement
local if_stmt
local repeat_stmt
local assign_stmt
local read_stmt
local write_stmt
local term
local simple_exp
local exp
local factor

function stmt_sequence()
    local token = curr_token()
    local s = statement()

    local p = s

    while token.id ~= TokenType.EOF and
        token.id ~= TokenType.END and
        token.id ~= TokenType.ELSE and
        token.id ~= TokenType.UNTIL do

        match(TokenType.SEMI)

        local q = statement()

        p.sibling = q
        p = q
    end

    return s
end

function statement()
    local s
    local token = curr_token()

    if token.id == TokenType.IF then
        s = if_stmt()
    elseif token.id == TokenType.REPEAT then
        s = repeat_stmt()
    elseif token.id == TokenType.ID then
        s = assign_stmt()
    elseif token.id == TokenType.READ then
        s = read_stmt()
    elseif token.id == TokenType.WRITE then
        s = write_stmt()
    else
        syntax_error("unexpected token ->", token_name(token.id), token.str)
        next_token()
    end

    return s
end

function if_stmt()
    local s = new_stmt_node(StatementKind.IF)
    local token = curr_token()

    match(TokenType.IF)
    table.insert(s.child, exp())
    match(TokenType.THEN)
    table.insert(s.child, stmt_sequence())

    if token.id == TokenType.ELSE then
        match(TokenType.ELSE)
        table.insert(s.child, stmt_sequence())
    end

    match(TokenType.END)

    return s
end

function repeat_stmt()
    local s = new_stmt_node(StatementKind.REPEAT)

    match(TokenType.REPEAT)
    table.insert(s.child, stmt_sequence())
    match(TokenType.UNTIL)
    table.insert(s.child, exp())

    return s
end

function assign_stmt()
    local token = curr_token()
    local s = new_stmt_node(StatementKind.ASSIGN, token.str)

    match(TokenType.ID)
    match(TokenType.ASSIGN)
    table.insert(s.child, exp())

    return s
end

function read_stmt()
    local token = curr_token()
    local s = new_stmt_node(StatementKind.READ, token.str)

    match(TokenType.READ)
    match(TokenType.ID)

    return s
end

function write_stmt()
    local s = new_stmt_node(StatementKind.WRITE)

    match(TokenType.WRITE)
    table.insert(s.child, exp())

    return s
end

function exp()
    local sexp = simple_exp()

    local token = curr_token()

    if token.id == TokenType.LT or token.id == TokenType.EQ then
        local exp = new_exp_node(ExpKind.OP, token.id, token.str)
        table.insert(exp.child, sexp)
        sexp = exp
        match(token.id)
        table.insert(exp.child, simple_exp())
    end

    return sexp
end

function simple_exp()
    local t = term()

    local token = curr_token()

    while token.id == TokenType.PLUS or token.id == TokenType.MINUS do
        local op = new_exp_node(ExpKind.OP, token.id, token.str)
        table.insert(op.child, t)
        t = op
        match(token.id)
        table.insert(op.child, term())
    end

    return t
end

function term()
    local f = factor()

    local token = curr_token()

    while token.id == TokenType.TIMES or token.id == TokenType.OVER do
        local exp = new_exp_node(ExpKind.OP, token.id, token.str)
        table.insert(exp.child, f)
        f = exp
        match(token.id)
        table.insert(exp.child, factor())
    end

    return f
end

function factor()
    local node
    local token = curr_token()

    if token.id == TokenType.NUM then
        node = new_exp_node(ExpKind.CONST, token.id, token.str)
        match(TokenType.NUM)
    elseif token.id == TokenType.ID then
        node = new_exp_node(ExpKind.ID, token.id, token.str)
        match(TokenType.ID)
    elseif token.id == TokenType.LPAREN then
        match(TokenType.LPAREN)
        node = exp()
        match(TokenType.RPAREN)
    else
        syntax_error("unexpected token ->", token_name(token.id), token.str)
        next_token()
    end

    return node
end

local function parse()
    local token = next_token()

    local node = stmt_sequence()

    if token.id ~= TokenType.EOF then
        syntax_error("Code ends before file")
    end

    trace(node)
    print(Inspect.inspect(node))

    return node
end

local global_indent = -4 

function trace(tree)
    global_indent = global_indent + 4

    while tree do
        -- Indent
        for i = 1, global_indent do
            io.write(" ")
        end

        if tree.node_kind == NodeKind.STATEMENT then
            if tree.kind == StatementKind.IF then
                print("If")
            elseif tree.kind == StatementKind.REPEAT then
                print("Repeat")
            elseif tree.kind == StatementKind.ASSIGN then
                print(string.format("Assign to: %s", tree.attr_str))
            elseif tree.kind == StatementKind.READ then
                print(string.format("Read: %s", tree.attr_str))
            elseif tree.kind == StatementKind.WRITE then
                print("Write")
            else
                print("Unknown Statement Node kind")
            end
        elseif tree.node_kind == NodeKind.EXP then
            if tree.kind == ExpKind.OP then
                print("Op: ", tree.attr_str)
            elseif tree.kind == ExpKind.CONST then
                print(string.format("Const: %d", tonumber(tree.attr_str)))
            elseif tree.kind == ExpKind.ID then
                print(string.format("Id: %s", tree.attr_str))
            else
                print("Unknown Exp Node kind")
            end
        else
            print("Unknown node kind")
        end

        for i = 1, #tree.child do
            trace(tree.child[i])
        end

        tree = tree.sibling
    end

    global_indent = global_indent - 4
end

return {
    parse = parse,
    trace = trace,
}
