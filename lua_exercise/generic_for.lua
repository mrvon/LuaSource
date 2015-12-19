--------------------------------------------------------------------------------
function generic_for(_f, _s, _var, block_callback)
    while true do
        local t = table.pack(_f(_s, _var))
        _var = t[1]

        if _var == nil then
            break
        end

        block_callback(table.unpack(t, 1, t.n))
    end
end
--------------------------------------------------------------------------------

local t = {
    Name = "skynet",
    Author = "Cloudwu",
}

generic_for(next, t, nil, function(...)
    print(...)
end)


--------------------------------------------------------------------------------
-- Simple way
for k, v in next, t, nil do
    print(k, v)
end
