local inspect = require "inspect"

print("-------------------")
for k in pairs(package) do
    print(k)
end

print("-------------------")
print("package.config")
print("-------------------")
print(inspect.inspect(package.config))

-- lua lib path
print("-------------------")
print("package.path")
print("-------------------")
print(inspect.inspect(package.path))

-- c lib path
print("-------------------")
print("package.cpath")
print("-------------------")
print(inspect.inspect(package.cpath))

-- preload-searcher, lua-searcher, c-searcher, all-in-one searcher
print("-------------------")
print(inspect.inspect(package.searchers))

-- preload table
print("-------------------")
print(inspect.inspect(package.preload))

-- function: Searches for the given name in the given path.
print("-------------------")
print(inspect.inspect(package.searchpath))

--[[
require

Once a loader is found, require calls the loader with two arguments: modname and
an extra value dependent on how it got the loader. (If the loader came from a
file, this extra value is the file name.) If the loader returns any non-nil
value, require assigns the returned value to package.loaded[modname]. If the
loader does not return a non-nil value and has not assigned any value to
package.loaded[modname], then require assigns true to this entry. In any case,
require returns the final value of package.loaded[modname].
]]

print("-------------------")
print("loaded table")
print("-------------------")

for k in pairs(package.loaded) do
    print(k)
end
