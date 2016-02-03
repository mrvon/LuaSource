-- utf8

local utf8_char = "€"
local utf8_char_list = "€€€€"

local code_point = utf8.codepoint(utf8_char)
print(code_point)
print(utf8.char(code_point))

-- utf8.charpattern

for p, c in utf8.codes(utf8_char_list) do
    print("Position:", p, "CodePoint:", c)
end

print("Len of char list", utf8.len(utf8_char_list))
