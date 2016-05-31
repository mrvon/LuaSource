a = {}
b = {
    __mode = "k",
}
setmetatable(a, b)

key = {}
a[key] = 1

key = {}
a[key] = 2

key_2 = {}
a[1] = key_2

key_2 = {}
a[2] = key_2

-- force a garbage collection cycle
collectgarbage()

for k, v in pairs(a) do
    print(k, v)
end

--------------------------------------------------------------------------------

local default_map = {}
setmetatable(default_map, {
    __mode = "k",
})

local default_mt = {
    __index = function(t)
        return default_map[t]
    end
}

local function set_default_value(t, d)
    default_map[t] = d
    setmetatable(t, default_mt)
end

local dt = {}
set_default_value(dt, "empty string")

print(dt[1])
print(dt["hello"])
dt.hello = "world"
print(dt["hello"])

--------------------------------------------------------------------------------

local meta_map = {}
setmetatable(meta_map, {
    __mode = "v",
})

local function set_default_value_2(t, d)
    local mt = meta_map[d]
    if mt == nil then
        mt = {
            __index = function(t)
                return d
            end
        }
        meta_map[d] = mt
    end
    setmetatable(t, mt)
end

local dt_2 = {}
set_default_value_2(dt_2, "empty_string")

print(dt_2[1])
print(dt_2.name)
dt_2.name = "Mrvon"
print(dt_2.name)
