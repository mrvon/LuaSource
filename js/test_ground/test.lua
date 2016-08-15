local myObject = (function()
    local value = 0

    return {
        increment = function(inc)
            if inc then
                value = value + inc
            else
                value = value + 1
            end
        end,
        getValue = function()
            return value
        end,
    }
end)()

print(myObject.getValue())
myObject.increment()
print(myObject.getValue())
myObject.increment(10)
print(myObject.getValue())

--[[
local function search()
    local constant_table = {
        name = "Dennis",
        age = 22,
    }

    return function(key)
        return constant_table[key]
    end
end

search = search()
]]

local search = (function()
    local constant_table = {
        name = "Dennis",
        age = 22,
    }

    return function(key)
        return constant_table[key]
    end
end)()

print(search('name'))
print(search('age'))
