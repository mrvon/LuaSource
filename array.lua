local array = require "array"

a = array.new(1000)

-- local metaarray = getmetatable(a)
-- metaarray.__index = metaarray
-- metaarray.get = array.get
-- metaarray.set = array.set
-- metaarray.size = array.size
-- print(a:size())
-- print(a.size(a))

local metaarray = getmetatable(a)
metaarray.__index = array.get
metaarray.__newindex = array.set
metaarray.__len = array.size
a[10] = true
print(a[10])
print(#a)

print(a)
print(array.size(a))
for i = 1, 1000 do
    array.set(a, i, i % 5 == 0)
end
print(array.get(a, 10))
