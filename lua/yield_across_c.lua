local f = coroutine.create(function()
    local t = require "yield"
    return t
end)
-- false   attempt to yield across a C-call boundary
print(coroutine.resume(f))
