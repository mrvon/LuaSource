print(package.path)
print(package.cpath)

local StringLib = assert(require "split")

local res = StringLib.split("HelloOrWorldOrWinOrFail", "Or")

for _, v in ipairs(res) do
    print(v)
end

path = package.path
print(package.searchpath("X", path))
print("package.searchers: " .. #package.searchers)

print("ComplexNum")
ComplexNum = assert(require "complex_number")

local m1 = ComplexNum.new(1, 1)
local m2 = ComplexNum.new(2, 2)
print(ComplexNum.tostring(m1))
print(ComplexNum.tostring(m2))
print(ComplexNum.tostring(ComplexNum.add(m1, m2)))
print(ComplexNum.tostring(ComplexNum.sub(m1, m2)))
print(ComplexNum.tostring(ComplexNum.mul(m1, m2)))
print(ComplexNum.tostring(ComplexNum.div(m1, m2)))


print("ComplexNum2")
ComplexNum2 = assert(require "complex_number_2")

local m1 = ComplexNum2.new(1, 1)
local m2 = ComplexNum2.new(2, 2)
print(ComplexNum2.tostring(ComplexNum2.add(m1, m2)))
print(ComplexNum2.tostring(ComplexNum2.sub(m1, m2)))
print(ComplexNum2.tostring(ComplexNum2.mul(m1, m2)))
print(ComplexNum2.tostring(ComplexNum2.div(m1, m2)))
