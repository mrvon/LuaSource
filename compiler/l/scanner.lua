-- Scanner for TINY language

local StateType = {
    START     = 1,
    INASSIGN  = 2,
    INCOMMENT = 3,
    INNUM     = 4,
    INID      = 5,
    DONE      = 6,
}

local TokenType = {
    -- reserve word
    IF                 = 1,
    THEN               = 2,
    ELSE               = 3,
    END                = 4,
    REPEAT             = 5,
    UNTIL              = 6,
    READ               = 7,
    WRITE              = 8,

    -- special symbols
    EOF                = 9,
    EQ                 = 10,
    LT                 = 11,
    PLUS               = 12,
    MINUS              = 13,
    TIMES              = 14,
    OVER               = 15,
    LPAREN             = 16,
    RPAREN             = 17,
    SEMI               = 18,
    ERROR              = 19,
    ASSIGN             = 20,

    -- other
    NUM                = 21,
    ID                 = 22,
}

local ReserveWords = {
    ["if"]     = TokenType.IF,
    ["then"]   = TokenType.THEN,
    ["else"]   = TokenType.ELSE,
    ["end"]    = TokenType.END,
    ["repeat"] = TokenType.REPEAT,
    ["until"]  = TokenType.UNTIL,
    ["read"]   = TokenType.READ,
    ["write"]  = TokenType.WRITE,
}

local g_input_buffer = {}
local g_token = {
    lineno = 1
}


local function get_next_char()
    if #g_input_buffer == 0 then
        return io.stdin:read(1)
    else
        local c = g_input_buffer[#g_input_buffer]
        g_input_buffer[#g_input_buffer] = nil
        return c
    end
end

local function unget_char(c)
    g_input_buffer[#g_input_buffer + 1] = c
end

local function is_digit(c)
    if c == nil then
        return false
    end

    local b = string.byte("0")
    local e = string.byte("9")
    local i = string.byte(c)
    if i >= b and i <= e then
        return true
    else
        return false
    end
end

local function is_letter(c)
    if c == nil then
        return false
    end

    local lb = string.byte("a")
    local le = string.byte("z")
    local ub = string.byte("A")
    local ue = string.byte("Z")
    local i = string.byte(c)
    if (i >= lb and i <= le) or (i >= ub and i <= ue) then
        return true
    else
        return false
    end
end

local function inc_lineno(c)
    -- support '\n', '\r', '\n\r', '\r\n'
    if c == '\n' then
        local n = get_next_char()
        if n ~= '\r' then
            unget_char(n)
        end
    elseif c == '\r' then
        local n = get_next_char()
        if n ~= '\n' then
            unget_char(n)
        end
    else
        assert(false)
    end

    g_token.lineno = g_token.lineno + 1
end

local function is_space(c)
    if c == nil then
        return false
    end

    if c == ' ' or c == '\t' then
        return true
    elseif c == '\n' or c == '\r' then
        inc_lineno(c)
        return true
    else
        return false
    end
end

local function curr_token()
    return g_token
end

local function next_token()
    local token_string_table = {}
    local token_id
    local state = StateType.START

    while state ~= StateType.DONE do
        local c = get_next_char()
        local save = true

        if state == StateType.START then
            if is_digit(c) then
                state = StateType.INNUM
            elseif is_letter(c) then
                state = StateType.INID
            elseif c == ':' then
                state = StateType.INASSIGN
            elseif is_space(c) then
                save = false
            elseif c == '{' then
                save = false
                state = StateType.INCOMMENT
            else
                state = StateType.DONE
                if c == nil then
                    save = false
                    token_id = TokenType.EOF
                elseif c == '=' then
                    token_id = TokenType.EQ
                elseif c == '<' then
                    token_id = TokenType.LT
                elseif c == '+' then
                    token_id = TokenType.PLUS
                elseif c == '-' then
                    token_id = TokenType.MINUS
                elseif c == '*' then
                    token_id = TokenType.TIMES
                elseif c == '/' then
                    token_id = TokenType.OVER
                elseif c == '(' then
                    token_id = TokenType.LPAREN
                elseif c == ')' then
                    token_id = TokenType.RPAREN
                elseif c == ';' then
                    token_id = TokenType.SEMI
                else
                    token_id = TokenType.ERROR
                end
            end
        elseif state == StateType.INCOMMENT then
            if c == '\n' or c == '\r' then
                inc_lineno(c)
            end
            save = false
            if c == '}' then
                state = StateType.START
            end
        elseif state == StateType.INASSIGN then
            state = StateType.DONE
            if c == '=' then
                token_id = TokenType.ASSIGN
            else
                unget_char(c)
                save = false
                token_id = TokenType.ERROR
            end
        elseif state == StateType.INNUM then
            if not is_digit(c) then
                unget_char(c)
                save = false
                state = StateType.DONE
                token_id = TokenType.NUM
            end
        elseif state == StateType.INID then
            if not is_letter(c) then
                unget_char(c)
                save = false
                state = StateType.DONE
                token_id = TokenType.ID
            end
        else
            print(string.format("Scanner Bug: state= %d", state))
            state = StateType.DONE
            token_id = TokenType.ERROR
        end

        if save then
            table.insert(token_string_table, c)
        end
    end

    local token_str = table.concat(token_string_table)
    if token_id == TokenType.ID then
        token_id = ReserveWords[token_str] or token_id
    end

    g_token.id = token_id
    g_token.str = token_str

    return g_token
end

local function token_name(token)
    for name, id in pairs(TokenType) do
        if id == token then
            return name
        end
    end
    error("find token name")
end

return {
    TokenType = TokenType,
    curr_token = curr_token,
    next_token = next_token,
    token_name = token_name,
}
