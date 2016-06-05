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
    ["if"]     = IF,
    ["then"]   = THEN,
    ["else"]   = ELSE,
    ["end"]    = END,
    ["repeat"] = REPEAT,
    ["until"]  = UNTIL,
    ["read"]   = READ,
    ["write"]  = WRITE,
}

local g_input_buffer = {}

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

local function is_space(c)
    if c == ' ' or c == '\t' or c == '\n' then
        return true
    else
        return false
    end
end

local function get_next_token()
    local token_string_table = {}
    local current_token
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
                    current_token = TokenType.EOF
                elseif c == '=' then
                    current_token = TokenType.EQ
                elseif c == '<' then
                    current_token = TokenType.LT
                elseif c == '+' then
                    current_token = TokenType.PLUS
                elseif c == '-' then
                    current_token = TokenType.MINUS
                elseif c == '*' then
                    current_token = TokenType.TIMES
                elseif c == '/' then
                    current_token = TokenType.OVER
                elseif c == '(' then
                    current_token = TokenType.LPAREN
                elseif c == ')' then
                    current_token = TokenType.RPAREN
                elseif c == ';' then
                    current_token = TokenType.SEMI
                else
                    current_token = TokenType.ERROR
                end
            end
        elseif state == StateType.INCOMMENT then
            save = false
            if c == ')' then
                state = StateType.START
            end
        elseif state == StateType.INASSIGN then
            state = StateType.DONE
            if c == '=' then
                current_token = TokenType.ASSIGN
            else
                unget_char(c)
                save = false
                current_token = TokenType.ERROR
            end
        elseif state == StateType.INNUM then
            if not is_digit(c) then
                unget_char(c)
                save = false
                state = StateType.DONE
                current_token = TokenType.NUM
            end
        elseif state == StateType.INID then
            if not is_letter(c) then
                unget_char(c)
                save = false
                state = StateType.DONE
                current_token = TokenType.ID
            end
        else
            print(string.format("Scanner Bug: state= %d", state))
            state = StateType.DONE
            current_token = TokenType.ERROR
        end

        if save then
            table.insert(token_string_table, c)
        end
    end

    local token_string = table.concat(token_string_table)
    if current_token == TokenType.ID then
        current_token = ReserveWords[token_string] or current_token
    end

    return current_token, token_string
end

local function find_token_name(token)
    for name, id in pairs(TokenType) do
        if id == token then
            return name
        end
    end
    error("find token name")
end

while true do
    local token, token_string = get_next_token()
    print(find_token_name(token), token_string)
end
