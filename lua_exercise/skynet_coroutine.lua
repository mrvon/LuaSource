local function yielding(co, from, ...)
    print("-- 7 --")

    print(co, from, ...)

    -- print(coroutine.yield(from, ...))

    coroutine.resume(co, from, coroutine.yield(from, ...))
end

local function resume(co, from, ok, ...)
    if not ok then
        return ok, ...
    elseif coroutine.status(co) == "dead" then
        return true, ...
    elseif (...) == "USER" then
        return true, select(2, ...)
    else 
        print("-- 6 --")
        resume(co, from, yielding(co, from, ...))
    end
end

local co = coroutine.create(function()
    print("-- 2 --")

    local caller = coroutine.running()
    print("co", caller)

    ----------------------------------------
    local co_2 = coroutine.create(function()
        print("-- 4 --")

        local self = coroutine.running()
        print("co_2", self)

        -- coroutine.yield("USER", "Let it go")
        print("-- 5 --")

        print(coroutine.yield("CALL", "Let it go"))

        print("-- 9 --")
    end)

    print("-- 3 --")
    print(resume(co_2, caller, coroutine.resume(co_2)))

    print("-- A --")
    ----------------------------------------
end)

local function suspend(ok, co, cmd, ...)
    print("-- 8 --")

    if cmd == "CALL" then
        coroutine.resume(co, "CALL RESULT")
    else
        assert(false)
    end
end

print("-- 1 --")
suspend(coroutine.resume(co))
print("-- B --")
