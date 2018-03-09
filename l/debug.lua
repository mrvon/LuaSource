local inspect = require "inspect"

local inspect = function(...)
    print(inspect.inspect(...))
end

local msg = "fuck"
local function fuck()
    print(msg)
    inspect(debug.getinfo(1))
end

fuck()
inspect(debug.getinfo(1))
inspect(debug.getinfo(fuck))

local meta = { }
meta.__index = meta

inspect(getmetatable(f))
inspect(getmetatable(setmetatable({}, meta)))

inspect(debug.getmetatable(f))
inspect(debug.getmetatable(debug.setmetatable({}, meta)))

-- registry

local REG = debug.getregistry()
local LUA_RIDX_MAINTHREAD = 1
local LUA_RIDX_GLOBALS = 2

inspect(REG[LUA_RIDX_MAINTHREAD])
-- inspect(REG[LUA_RIDX_GLOBALS])
assert(REG[LUA_RIDX_GLOBALS] == _G)
assert(REG[LUA_RIDX_GLOBALS] == _ENV)

-- getupvalue

local msg = "hello world"
local function test()
    inspect(msg)
end

local msg = "hello my friend"
local function test_2()
    inspect(msg)
end

inspect(debug.getinfo(test))

local function inspect_upvalue(var)
    print("---------------- upvalue")
    for i = 1, math.huge do
        local upname, upval = debug.getupvalue(var, i)
        if upname == nil then
            break
        end
        inspect(upname)
        inspect(upval)
    end
    print("---------------- >")
end

inspect_upvalue(test)

assert(debug.setupvalue(test, 2, "fuck you") == "msg")

inspect_upvalue(test)

-- debug.upvalueid (f, n)
--
-- Returns a unique identifier (as a light userdata) for the upvalue numbered n
-- from the given function.

assert(debug.upvalueid(test, 1) == debug.upvalueid(test_2, 1))
assert(debug.upvalueid(test, 2) ~= debug.upvalueid(test_2, 2))

test()

-- debug.upvaluejoin (f1, n1, f2, n2)
--
-- Make the n1-th upvalue of the Lua closure f1 refer to the n2-th upvalue of
-- the Lua closure f2.

debug.upvaluejoin(test, 2, test_2, 2)
assert(debug.upvalueid(test, 2) == debug.upvalueid(test_2, 2))

test()
