local binary_1 = string.pack('>s2', "fuckyou")
local binary_2 = string.pack('>s4', "fuckyou")

print(binary_1)
print(binary_2)

local binary_3 = string.pack('>s2', "1024")
local original_3, pos_3 = string.unpack('>s2', binary_3)
print(original_3)
assert(string.sub(binary_3, pos_3) == "")
print(string.unpack('H', binary_3))


local tail = "hello world"
local binary_4 = string.pack('>s4', "1024") .. tail
local original_4, pos_4 = string.unpack('>s4', binary_4)
print(original_4)
print(string.sub(binary_4, pos_4))
