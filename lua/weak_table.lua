-- if either the key or the value is collected, the whole pair is removed from the table.


local function mode_k()
    local t = {}
    local mt = {
        __mode = "k",
    }
    -- weak key, strong value
    setmetatable(t, mt)

    local weak_key_1 = {}
    local weak_key_2 = {}
    local strong_val_1 = {}
    local strong_val_2 = {}

    t[weak_key_1] = strong_val_1
    t[weak_key_2] = strong_val_2

    -- value 1, value 2 will not be collected, it's strong value reference in
    -- table
    strong_val_1 = nil
    strong_val_2 = nil

    -- force a garbage collection cycle
    collectgarbage()

    for k, v in pairs(t) do
        print(k, v)
    end

    print("------------------------------------------------")

    -- key 1 will be collected, the whole pair is remove
    weak_key_1 = nil

    -- force a garbage collection cycle
    collectgarbage()

    for k, v in pairs(t) do
        print(k, v)
    end
end

local function mode_v()
    local t = {}
    local mt = {
        __mode = "v",
    }
    -- strong key, weak value
    setmetatable(t, mt)

    local strong_key_1 = {}
    local string_key_2 = {}
    local weak_val_1 = {}
    local weak_val_2 = {}

    t[strong_key_1] = weak_val_1
    t[string_key_2] = weak_val_2

    -- value 1 will be collected, the whole pair is remove
    weak_val_1 = nil

    -- force a garbage collection cycle
    collectgarbage()

    for k, v in pairs(t) do
        print(k, v)
    end
end

local function mode_kv()
    local t = {}
    local mt = {
        __mode = "kv",
    }
    -- weak key, weak value
    setmetatable(t, mt)

    -- will not be collected
    t[1] = 1
    t[2] = "World"
    t["Hello"] = 1

    -- will be collected
    t[3] = {}
    t[{}] = 3

    -- force a garbage collection cycle
    collectgarbage()

    for k, v in pairs(t) do
        print(k, v)
    end
end

-- mode_k()
-- mode_v()
-- mode_kv()

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
