-- local prototype = {x = 0, y = 0, width = 100, height = 100}
-- local mt = {}

-- function new(o)
--     setmetatable(o, mt)
--     return o
-- end

-- -- mt.__index = function(_, key)
-- --     return prototype[key]
-- -- end

-- mt.__index = prototype

-- w = new({x = 10, y = 20})

-- print("------------- Get with metatable")
-- print(w.x)
-- print(w.y)
-- print(w.width)
-- print(w.height)
-- print(w.z)

-- print("------------- Raw get without metatable")
-- print(rawget(w, "x"))
-- print(rawget(w, "y"))
-- print(rawget(w, "width"))
-- print(rawget(w, "height"))
-- print(rawget(w, "z"))

-- print("------------- Table with default values")
-- local mt = {__index = function(t) return t.___ end}
-- function setdefault(t, d)
--     t.___ = d
--     setmetatable(t, mt)
-- end

-- local t1 = {}
-- setdefault(t1, 0)
-- print(t1[1])
-- print(t1[2])

-- original table (created somewhere)
t = {}

-- keep a private access to the original table
local _t = t

-- create proxy
t = {}

-- create metatable
local mt = {
    __index = function(t, k)
        print("*access to element " .. tostring(k))
        return _t[k]  -- access the original table
    end,

    __newindex = function(t, k, v)
        print("*update the element " .. tostring(k) .. " to " .. tostring(v))
        _t[k] = v -- update original table
    end,

    __pairs = function()
        return function(_, k)
            return next(_t, k)
        end
    end,

    __ipairs = function()
        local i = 0
        return function(_)
            i = i + 1
            if _t[i] then
                return i , _t[i]
            else
                return
            end
        end
    end,
}
setmetatable(t, mt)

t[1] = "world"
t[2] = "hello"
t[3] = "programming"
t["false"] = false
t["true"] = true

for k, v in pairs(t) do
    print(k, v)
end

for i, v in ipairs(t) do
    print(i, v)
end

print("---------------- Read only Table Version 1")
function readonly(t)
    local proxy = {}
    local mt = { -- create metatable
        __index = t,
        __newindex = function(t, k, v)
            error("attemp to update a read-only table", 2)
        end
    }
    setmetatable(proxy, mt)
    return proxy
end

local t = {"hello world", "yes", "no"}
local t = readonly(t)
print(t[1])
print(t[2])
print(t[3])
-- t[1] = "false"


print("---------------- Read only Table Version 2")
local readonly_mt = {
    __index = function(t, k)
        return t.__original_table[k]
    end,

    __newindex = function(t, k, v)
        error("attemp to update a read-only table", 2)
    end,
}

function readonly2(t)
    local readonly_proxy = {}
    readonly_proxy.__original_table = t
    setmetatable(readonly_proxy, readonly_mt)
    return readonly_proxy
end

local t = {"mac", "osx", "vim"}
local t = readonly2(t)
print(t[1])
print(t[2])
print(t[3])
-- t[1] = "win"
