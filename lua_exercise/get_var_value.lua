function getvarvalue(name, level)
    local value
    local found = false

    level = (level or 1) + 1

    -- try local variables
    for i = 1, math.huge do
        local n, v = debug.getlocal(level, i)
        if not n then
            break
        end
        if n == name then
            value = v
            found = true
        end
    end

    if found then
        return value
    end

    -- try non-local variables
    local func = debug.getinfo(level, "f").func
    for i = 1, math.huge do
        local n, v = debug.getupvalue(func, i)
        if not n then
            break
        end
        if n == name then
            return v
        end
    end

    -- not found
    local env = getvarvalue("_ENV", level)
    return env[name]
end

local k = "Hello girl"
l = "Hello Miss liyun"

function create_closure()
    local j = "Hello world"
    return function()
        local i = 1000
        local m = j
        local n = k
        print("local i: " .. getvarvalue("i"))
        print("upvalue j: " .. getvarvalue("j"))
        print("upvalue(outer) k: " .. getvarvalue("k"))
        print("global l: " .. getvarvalue("l"))
    end
end

local c = create_closure()
c()
