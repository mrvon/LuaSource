-- Scanner for simple calculator

local StateType = {
    START     = 1,
    INNUM     = 2,
    DONE      = 3,
}

local TokenType = {
    -- special symbols
    EOF                = 1,
    ERROR              = 2,
    PLUS               = 3,
    MINUS              = 4,
    TIMES              = 5,
    OVER               = 6,
    LPAREN             = 7,
    RPAREN             = 8,
    SEMI               = 9,

    -- other
    NUM                = 10,
}


local g_input_buffer = {}
local g_token = {}

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

local function is_space(c)
    if c == nil then
        return false
    end

    if c == ' ' or c == '\t' or c == '\n' or c == '\r' then
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
            elseif is_space(c) then
                save = false
            else
                state = StateType.DONE
                if c == nil then
                    save = false
                    token_id = TokenType.EOF
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
        elseif state == StateType.INNUM then
            if not is_digit(c) then
                unget_char(c)
                save = false
                state = StateType.DONE
                token_id = TokenType.NUM
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

    g_token.id = token_id
    g_token.str = token_str

    return g_token
end

return {
    TokenType = TokenType,
    curr_token = curr_token,
    next_token = next_token,
}
