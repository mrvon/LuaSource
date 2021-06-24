local SimpleLib = require "simple_lib"

local co = coroutine.wrap(function()
    local t = {
        ["Hello"] = 1,
        ["World"] = 2,
    }
    SimpleLib.foreach_c_yieldable(t, function(k, v)
        coroutine.yield(k, v)
    end)
end)

print(co())
print(co())
