function test()
    local i = 100
    i = i + 1
    return i
end


--[[
debug.sethook(print, "l")
]]

--[[
function trace(event, line)
    local s = debug.getinfo(2).short_src
    print(s .. ":" .. line)
end
debug.sethook(trace, "l")
]]

--[[
debug.sethook(debug.debug, "ct")
]]

function debug1()
    while true do
        io.write("debug> ")
        local line = io.read()
        if line == "cont" then
            break
        end
        assert(load(line))
    end
end

test()
debug1()
