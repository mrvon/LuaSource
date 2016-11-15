-- Scanner for JSON

local StateType = {
    START     = 1,
    INDIGIT   = 2,
    INSTR     = 3,
    DONE      = 4,
}

local TokenType = {
    LBRACE    = 1,
    RBRACE    = 2,
    LBRACKET  = 3,
    RBRACKET  = 4,
    STR       = 5,
    DIGIT     = 6,
    TRUE      = 7,
    FALSE     = 8,
    NULL      = 9,
    SEMI      = 11,
    EOF       = 14,
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

local function is_char()
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
                state = StateType.INDIGIT
            elseif c == '\"' then
                save = false
                state = StateType.INSTR
            elseif is_space(c) then
                save = false
            else
                state = StateType.DONE
                if c == nil then
                    save = false
                    token_id = TokenType.EOF
                elseif c == '{' then
                    token_id = TokenType.LBRACE
                elseif c == '}' then
                    token_id = TokenType.RBRACE
                elseif c == '[' then
                    token_id = TokenType.LBRACKET
                elseif c == ']' then
                    token_id = TokenType.RBRACKET
                elseif c == ';' then
                    token_id = TokenType.SEMI
                else
                    token_id = TokenType.ERROR
                end
            end
        elseif state == StateType.INDIGIT then
            if not is_digit(c) then
                unget_char(c)
                save = false
                state = StateType.DONE
                token_id = TokenType.DIGIT
            end
        elseif state == StateType.INSTR then
            if c == '\"' then
                save = false
                state = StateType.DONE
                token_id = TokenType.STR
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
