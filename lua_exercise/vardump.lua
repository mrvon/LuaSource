function vardump(value, depth, key)
    local line_prefix = ""
    local spaces = ""
    local indent_str = string.rep(" ", 4)

    if key then
        line_prefix = "["  .. key .. "] = "
    end

    if depth == nil then
        depth = 0
    else
        depth = depth + 1
        for i = 1, depth do
            spaces = spaces .. indent_str
        end
    end

    if type(value) == "table" then
        local meta_table = getmetatable(value)
        if meta_table == nil then
            print(spaces .. line_prefix .. "(table) " .. "without metatable")
        else
            print(spaces .. line_prefix .. "(table)" .. "(with metatable [" ..
                tostring(meta_table) .. "])")
        end

        for k, v in pairs(value) do
            vardump(v, depth, k)
        end
    elseif type(value) == "function"
        or type(value) == "thread"
        or type(value) == "userdata"
        or value == nil then
        print(spaces .. line_prefix .. tostring(value))
    else
        print(spaces .. line_prefix .. "(" .. type(value) .. ") " .. tostring(value))
    end
end


a = { "header", 1, 2, 3, 4, 5, "tail"}
b = {
    name = "Mrvon",
    age = 18,
    subtable = a,
    sin = math.sin,
}
setmetatable(a, {
    __index = function(t, k)
        print(string.format("key(%s) is missing", k))
    end
})

vardump(b, nil, "b")
