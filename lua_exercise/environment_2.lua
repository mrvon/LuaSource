--[[

function declare(name, init_val)
    rawset(_G, name, init_val or false)
end

setmetatable(_G, {
    __newindex = function(_, n)
        error("attempt to write to undeclared variable " .. n, 2)
    end,

    __index = function(_, n)
        error("attempt to read undeclared variable " .. n, 2)
    end,
})

-- a = 10
declare("a", 10)
print(a)

]]


--[[
setmetatable(_G, {
    __newindex = function(t, n, v)
        local w = debug.getinfo(2, "S").what
        print("What: " .. w)
        if w ~= "main" and w ~= "C" then
            error("attempt to write to undeclared variable " .. n, 2)
        end
        rawset(t, n, v)
    end,

    __index = function(_, n)
        error("attempt to read undeclared variable " .. n, 2)
    end,
})

function set_global_val()
    a = 10
end
set_global_val()
print(a)
]]

--[[
local declared_names = {}
setmetatable(_G, {
    __newindex = function(t, n, v)
        if not declared_names[n] then
            local w = debug.getinfo(2, "S").what
            if w ~= "main" and w ~= "C" then
                error("attempt to write to undeclared variable " .. n, 2)
            end
            declared_names[n] = true
        end
        rawset(t, n, v) -- do the actual set
    end,

    __index = function(_, n)
        if not declared_names[n] then
            error("attempt to read undeclared variable " .. n, 2)
        else
            return nil
        end
    end,
})

a = 10
print(10)
a = nil
print(a)
function set_global_val()
    a = 10
end
set_global_val()
print(a)
]]


--[[
local print, sin = print, math.sin
_ENV = nil

print(13)
print(sin(13))
-- print(math.sin(13))

-- a = 13
local a = 13
print(a)
-- print(_ENV.a)
]]


--[[
-- change current environment to a new empty table
a = 15
_ENV = {g = _G}
a = 1
g.print(a)
g.print(g.a)
]]


--[[
a = 15
_ENV = {_G = _G}
a = 1
_G.print(a)
_G.print(_G.a)
]]


--[[
local Global = _G

a = 1
local newgt = {}
setmetatable(newgt, {
    __index = function(t, n)
        return Global[n]
    end
})
_ENV = newgt

Global.print(a)
]]


--[[
a = 1
local newgt = {}
setmetatable(newgt, {
    __index = _G,
})
_ENV = newgt
print(a)

-- continuing previous code
a = 10
print(a)
print(_G.a)
_G.a = 20
print(_G.a)
]]


--[[
_ENV = {
    _G = _G,
}
local function foo()
    _G.print(a)
end

a = 10
foo()

_ENV = {
    _G = _G,
    a = 100
}
foo()
]]


--[[
a = 2
do
    local _ENV = {
        print = print,
        a = 14,
    }

    print(a)
end
print(a)
]]


--[[
function factory(_ENV)
    return function()
        return a
    end
end


f1 = factory({a = 6})
f2 = factory({a = 7})
print(f1())
print(f2())
]]


--[[
local hello_world_local_variable = true

for v in pairs(_ENV) do
    print(v)
end

print(hello_world_local_variable)
--]]


--[[
local foo
do
    local _ENV = _ENV
    function foo()
        print(X)
    end
end

print(foo)
print(_ENV.foo)

X = 13
_ENV = nil
foo()
-- X = 0
]]


--[[
local print = print
function foo(_ENV, a)
    print(a + b)
end

foo({b = 14}, 12)
foo({b = 10}, 1)
]]

