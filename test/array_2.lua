local array = require "array"

a = array.new(1000)

print(a)
print(a:size())
print(a.size(a))
print(array.size(a))
for i = 1, 1000 do
    array.set(a, i, i % 5 == 0)
end
print(array.get(a, 10))
