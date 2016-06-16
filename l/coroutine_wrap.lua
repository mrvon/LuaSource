--[[
coroutine.wrap (f)
    Creates a new coroutine, with body f. f must be a function. Returns a function 
    that resumes the coroutine each time it is called. Any arguments passed to the 
    function behave as the extra arguments to resume. Returns the same values returned 
    by resume, except the first boolean. In case of error, propagates the error.
]]


local global_counter = 0

local f = coroutine.wrap(function()
    while true do
        local add = coroutine.yield(string.format("Hello world %d", global_counter))
        global_counter = global_counter + add
    end
end)
f()

print(f(1))
print(f(2))
print(f(3))
print(f(4))

-------------------------------------------------------------------------------
local global_counter = 0

-- use coroutine.create simulate it.
function coroutine_wrap(func)
    local co = coroutine.create(func)
    return function(...)
        return select(2, coroutine.resume(co, ...))
    end
end

local f = coroutine_wrap(function()
    while true do
        local add = coroutine.yield(string.format("Hello world %d", global_counter))
        global_counter = global_counter + add
    end
end)
f()

print(f(1))
print(f(2))
print(f(3))
print(f(4))
