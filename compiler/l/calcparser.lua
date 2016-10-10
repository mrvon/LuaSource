--[[
Simple integer arithmetic calculator
according to the EBNF:

<exp>    -> <term> { <addop> <term> } ;
<addop>  -> + | -
<term>   -> <factor> { <mulop> <factor> }
<mulop>  -> * | /
<factor> -> ( <exp> ) | Number


Inputs a line of text from the stdin
Outputs "Error" or the result.
]]

local Scanner = require "scanner"
local Inspect = require "inspect"

local TokenType = Scanner.TokenType

-- *curr_token* always return the same table instance
local curr_token = Scanner.curr_token
local next_token = Scanner.next_token
local token_name = Scanner.token_name

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
        syntax_error("unexpected token ->", token_name(token.id), token.str)
    end
end

local exp
local term
local factor

function exp()
    local token = curr_token()
    local temp = term()

    while token.id == TokenType.PLUS or token.id == TokenType.MINUS do
        local op = token.id

        -- save old token.id before you move on.
        match(token.id)

        if op == TokenType.PLUS then
            temp = temp + term()
        else
            temp = temp - term()
        end
    end

    return temp
end

function term()
    local token = curr_token()
    local temp = factor()

    while token.id == TokenType.TIMES or token.id == TokenType.OVER do
        local op = token.id

        -- save old token.id before you move on.
        match(token.id)

        if op == TokenType.TIMES then
            temp = temp * factor()
        else
            temp = temp / factor()
        end
    end

    return temp
end

function factor()
    local token = curr_token()

    if token.id == TokenType.NUM then
        local n  = tonumber(token.str)
        match(token.id)
        return n
    elseif token.id == TokenType.LPAREN then
        match(TokenType.LPAREN)
        local e = exp()
        match(TokenType.RPAREN)
        return e
    else
        syntax_error("unexpected token ->", token_name(token.id), token.str,
        "should be <factor> here.")
    end
end

local function parse()
    local token = next_token()

    while token.id ~= TokenType.EOF do
        print("=", exp())
        match(TokenType.SEMI)
    end
end

return {
    parse = parse,
}
