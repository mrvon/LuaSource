--[[
http://www.json.org/
JSON BNF

object
    {}
    { members }
members
    pair
    pair , members
pair
    string : value
array
    []
    [ elements ]
elements
    value 
    value , elements
value
    string
    number
    object
    array
    true
    false
    null
string
    ""
    " chars "
chars
    char
    char chars
char
    any-Unicode-character-
        except-"-or-\-or-
        control-character
    \"
    \\
    \/
    \b
    \f
    \n
    \r
    \t
    \u four-hex-digits
number
    int
    int frac
    int exp
    int frac exp
int
    digit
    digit1-9 digits 
    - digit
    - digit1-9 digits
frac
    . digits
exp
    e digits
digits
    digit
    digit digits
e
    e
    e+
    e-
    E
    E+
    E-
]]

local Scanner = require "jsonscanner"
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
        syntax_error("unexpected token ->", token_name(token.id), token.str,
        "expected token ->", token_name(expected))
    end
end


local object
local members
local pair
local value
local array
local elements

object = function()
    local token = curr_token()
    local obj = {}
    match(TokenType.LBRACE)
    if token.id == TokenType.RBRACE then
        match(TokenType.RBRACE)
    else
        local m = members(obj)
        match(TokenType.RBRACE)
    end
    return obj
end

members = function(obj)
    local token = curr_token()
    pair(obj)
    while token.id == TokenType.COMMA do
        match(TokenType.COMMA)
        pair(obj)
    end
end

pair = function(obj)
    local token = curr_token()
    local key = token.str
    match(TokenType.STR)
    match(TokenType.COLON)
    local val = value()
    obj[key] = val
end

value = function()
    local token = curr_token()

    if token.id == TokenType.STR then
        local val = token.str
        match(TokenType.STR)
        return val
    elseif token.id == TokenType.NUM then
        -- FIXME
        local num = tonumber(token.str)
        match(TokenType.NUM)
        return num
    elseif token.id == TokenType.LBRACE then
        return object()
    elseif token.id == TokenType.LBRACKET then
        return array()
    elseif token.id == TokenType.TRUE then
        match(TokenType.TRUE)
        return true
    elseif token.id == TokenType.FALSE then
        match(TokenType.FALSE)
        return false
    elseif token.id == TokenType.NULL then
        match(TokenType.NULL)
        return nil
    else
        syntax_error("value, unexpected token ->", token.str)
    end
end

elements = function(arr)
    local token = curr_token()
    table.insert(arr, value())
    while token.id == TokenType.COMMA do
        match(TokenType.COMMA)
        table.insert(arr, value())
    end
end

array = function()
    local token = curr_token()
    local arr = {}
    match(TokenType.LBRACKET)
    if token.id == TokenType.RBRACKET then
        match(TokenType.RBRACKET)
    else
        elements(arr)
        match(TokenType.RBRACKET)
    end
    return arr
end

local function parse()
    local token = next_token()
    local obj = object()

    if token.id ~= TokenType.EOF then
        syntax_error("JSON file syntax error")
    end

    return obj
end

return {
    parse = parse,
}
