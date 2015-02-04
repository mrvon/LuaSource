-- original table(created somewhere)
t = {}  

-- keep a private access to the original table
local _t = t

-- create proxy
t = {}

-- create metatable
local mt = {
    __index = function(t, k)
        print("*Access to element " .. tostring(k))
        return _t[k]    -- access the original table
    end,

    __newindex = function(t, k, v)
        print("*Update of element " .. tostring(k) .. " to " .. tostring(v))
        _t[k] = v       -- update original table
    end,

    __pairs = function()
        print("Invoking __pairs")
        return function(t, k)
            return next(_t, k)
        end
    end,

    __ipairs = function()
        print("Invoking __ipairs")
        local i = 0
        return function(t, k)
            i = i + 1
            return _t[i]
        end
    end
}
setmetatable(t, mt)

t[1] = "output"
t[2] = "hello"
t[3] = "world"
t[4] = "foo"
t[5] = "goo"
t["name"] = "UNNAME"
t["id"]   = 1

print(t[2])

for k, v in pairs(t) do
    print(k, v)
end

for v in ipairs(t) do
    print(v)
end

function ReadOnly(t)
    local proxy = {}
    local mt = {
        __index = t,
        __newindex = function(t, k, v)
            error("attempt to update a read-only table", 2)
        end
    }
    setmetatable(proxy, mt)
    return proxy
end

days = ReadOnly({
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
})
print(days[1])
-- days[2] = "Noday"
