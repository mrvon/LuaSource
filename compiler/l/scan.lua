local scanner = require "scanner"

while true do
    local token, token_string = scanner.get_token()
    if token == scanner.TokenType.EOF then
        break
    end

    print(token, scanner.token_name(token), token_string)
end
