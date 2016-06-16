function traceback()
    for level = 1, math.huge do
        local info = debug.getinfo(level)
        if not info then
            break
        end
        if info.what == "C" then
            print(level, "C function")
        else
            print(string.format("[%s]:%d in function %s", 
                info.short_src, 
                info.currentline,
                info.name))
        end
    end
end

function main()
    test()
end

function test()
    print(test_2())
end

function test_2()
    local msg = debug.traceback()
    print(msg)
    traceback()
    return "Hello world"
end

main()
