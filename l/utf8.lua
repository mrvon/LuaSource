-- utf8

local utf8_char = "€"
local utf8_char_sequence = "€€€€"

-- this *code point* is decimal representation
local code_point = utf8.codepoint(utf8_char)

-- print *code point* with hexidecimal representation
print(string.format("Code Point: %X", code_point))

-- print utf8 char corresponds to *code point*
print(utf8.char(code_point))

-- utf8.charpattern

-- traversal utf8 char sequence
for p, c in utf8.codes(utf8_char_sequence) do
    print(string.format("Position(in the sequence): %d\tCodePoint: %X", p, c))
end

-- how many utf8 char in this sequence
print("Len of char sequence", utf8.len(utf8_char_sequence))

io.write("utf8 MEMORY Byte List: ")
for i = 1, string.len(utf8_char) do
    io.write(string.format("%X ", string.byte(utf8_char, i)))
end
io.write("\n")

-- use utf8 in literal string
print("\u{20AC}")
