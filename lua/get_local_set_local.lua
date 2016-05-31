function test_getlocal(a, b, ...)
    local x
    do
        local c = a - b
    end
    local a = 1
    while true do
        local name, value = debug.getlocal(1, a)
        if not name then
            break
        end
        print(name, value)
        a = a + 1
    end

    local i = -1
    while true do
        local extra_name, extra_value = debug.getlocal(1, i)
        if not extra_name then
            break
        end
        print(extra_name, extra_value)
        i = i - 1
    end
end

test_getlocal(10, 20, 1, 2, 3, 4)

function test_setlocal()
    local x
    setlocal("x", "hello world")
    setlocal("y", "hello world")
    print(x)
    print(y)
end

function setlocal(var_name, var_value)
    local i = 1
    while true do
        local name, value = debug.getlocal(2, i)
        if name == nil then
            return
        end

        if name == var_name then
            debug.setlocal(2, i, var_value)
            return
        end

        i = i + 1
    end
end

test_setlocal()
