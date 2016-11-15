local Scanner = require "jsonscanner"
local TokenType = Scanner.TokenType

while true do
    local token = Scanner.next_token()

    if token.id == TokenType.EOF then
        break
    end

    print(token.id, token.str)
end
