-- a = 1

-- -- for n in pairs(_G) do
-- --     print(n)
-- -- end

-- print(_G["a"])
-- _G["a"] = 2
-- print(_G["a"])
-- print(type(_G["print"]))
-- print(type(io.read))
-- print(type(_G["io.read"]))

function getfield(f)
    local v = _G
    for w in string.gmatch(f, "[%w_]+") do
        v = v[w]
    end
    return v
end

local sys_write = getfield("io.write")
sys_write("Hello world\n")

-- function setfield(f, v)
--     local t = _G                                     -- start with the table of globals
--     for w, d in string.gmatch(f, "([%w_]+)(%.?)") do
--         if d == "." then                             -- not last name?
--             t[w] = t[w] or {}                        -- create table if absent
--             t = t[w]                                 -- get the table
--         else                                         -- last name
--             t[w] = v                                 -- do the assignment
--         end
--     end
-- end

-- setfield("b.c.d", 1)
-- print(b)
-- print(b.c)
-- print(b.c.d)
-- print(getfield("b.c.d"))

print("-------------------declare")
-- function declare(name, initval)
--     rawset(_G, name, initval or false)
-- end

-- setmetatable(_G, {
--     __index = function(_, n)
--         error("attempt to read undeclared variable", 2)
--     end,

--     __newindex = function(_, n)
--         error("attempt to write to undeclared variable", 2)
--     end,
-- })

-- declare("t", 1)
-- print(t)

print("---------------------Use _ENV")
-- local print, sin = print, math.sin
-- _ENV = nil
-- print(13)
-- print(sin(13))
-- print(math.cos(13))

-- a = 13
-- local a = 12
-- print(a)
-- print(_ENV.a)

-- print(_ENV == _G)
-- a = 15
-- _ENV = {g = _G}
-- a = 1
-- g.print(a)
-- g.print(g.a)

-- a = 1
-- local newgt = {}
-- setmetatable(newgt, {__index = _g})
-- _env = newgt
-- print(a)

-- a = 10
-- print(a)
-- print(_g.a)
-- _g.a = 29
-- print(a)
-- print(_G.a)

-- _ENV = {_G = _G}
-- local function foo()
--     _G.print(a)
-- end
-- a = 10
-- foo()

-- _ENV = {_G = _G, a = 20}
-- foo()

-- a = 2
-- do
--     local _ENV = {print = print, a = 14}
--     print(a)
-- end
-- print(a)

-- function factory(_ENV)
--     return function()
--         return a
--     end
-- end

-- f1 = factory({a = 6})
-- f2 = factory({a = 7})
-- print(f1())
-- print(f2())

-- local foo
-- do
--     local _ENV = _ENV
--     function foo()
--         print(X)
--     end
-- end
-- X = 13
-- _ENV = nil
-- foo()
-- X = 0

-- local print = print
-- function foo(_ENV, a)
--     print(a + b)
-- end
-- foo({b = 14}, 12)
-- foo({b = 10}, 1)
