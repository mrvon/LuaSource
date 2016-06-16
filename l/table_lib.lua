function pairsByKeys(t)
    local a = {}
    for n in pairs(t) do
        a[#a + 1] = n
    end
    table.sort(a)
    local i = 0 -- iterator variable
    return function()
        i = i + 1
        return a[i], t[a[i]]
    end
end

lines = {
    luaH_set = 10,
    luaH_get = 24,
    luaH_present = 48,
}

for name, line in pairsByKeys(lines) do
    print(name, line)
end

function rconcat(l, sep)
    if type(l) ~= "table" then
        return l
    end
    local res = {}
    for i = 1, #l do
        res[i] = rconcat(l[i], sep)
    end
    return table.concat(res, sep)
end

print(rconcat({{"a", {" nice"},}, " and", {{" long"}, {" list"}}}, ";"))
