function print_running()
    local co, is_main = coroutine.running()
    print("co:", co, "is main thread:", is_main)
end

local co_2 = coroutine.create(function(...)
    local from_co = ...
    print(4, coroutine.status(from_co))
end)

local co = coroutine.create(function(...)
    print_running()
    print(...)
    print(2, coroutine.status(coroutine.running()))
    local other_co = coroutine.yield()

    coroutine.resume(other_co, coroutine.running())
end)

print(1, coroutine.status(co))

print_running()
coroutine.resume(co, "Hello", "World")

print(3, coroutine.status(co))

coroutine.resume(co, co_2)

print(5, coroutine.status(co))
