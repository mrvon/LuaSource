local o = {
    final_message = "Hello Test 1",
}

setmetatable(o, {
    __gc = function(o)
        print(o.final_message)
    end
})

o = nil

collectgarbage()

--------------------------------------------------------------------------------

local o = {
    final_message = "Hello Test 2",
}

local mt = {
}

setmetatable(o, mt)

mt.__gc = function(o)
    print(o.final_message)
end

-- You should put "setmetatable" after you set __gc

o = nil

collectgarbage()

--------------------------------------------------------------------------------

local o = {
    final_message = "Hello Test 3",
}

local mt = {
    __gc = true,    -- a placeholder
}

setmetatable(o, mt)

mt.__gc = function(o)
    print(o.final_message)
end

o = nil

collectgarbage()

--------------------------------------------------------------------------------

local mt = {
    __gc = function(o)
        print(o[1])
    end
}

local list = nil

for i = 1, 3 do
    list = setmetatable({
        i, link = list
    }, mt)
end

list = nil

collectgarbage()

--------------------------------------------------------------------------------

local ga = nil
local a = {
    x = "this is a"
}
local b = {
    f = a
}
setmetatable(a, {
    __gc = function(o)
        print("run a finallzer")
    end
})
setmetatable(b, {
    __gc = function(o)
        ga = o.f
        print(o.f.x)
    end
})
a = nil
b = nil
collectgarbage()

--------------------------------------------------------------------------------

_G.AA = {
    __gc = function()
        -- your 'atexit' code comes here
        print("finishing Lua program")
    end
}
setmetatable(_G.AA, _G.AA)

--------------------------------------------------------------------------------

do
    local mt = {
        __gc = function(o)
            -- whatever you want to do
            print("new cycle")
            -- creates new object for next cycle
            setmetatable({}, getmetatable(o))
        end
    }
    --creates first object
    setmetatable({}, mt)
end

collectgarbage()
collectgarbage()
collectgarbage()
--------------------------------------------------------------------------------

-- a table with weak key
local wk = setmetatable({}, {__mode = "k"})
-- a table with weak value
local wv = setmetatable({}, {__mode = "v"})

local o = {}
wk[o] = 1
wv[1] = o

setmetatable(o, {
    __gc = function(o)
        print(wk[o], wv[o])
    end
})

o = nil
collectgarbage()
