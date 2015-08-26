function vardump(value, depth, key)
    local line_prefix = ""
    local spaces = ""

    if key then
        line_prefix = "["  .. key .. "] = "
    end

    if depth == nil then
        depth = 0
    else
        depth = depth + 1
        for i = 1, depth do
            spaces = spaces .. string.rep(" ", 4)
        end
    end

    if type(value) == "table" then
        local meta_table = getmetatable(value)
        if meta_table == nil then
            print(spaces .. line_prefix .. "(table) ")
        else
            print(spaces .. "(metatable) ")
            value = meta_table
        end

        for key, value in pairs(value) do
            vardump(value, depth, key)
        end
    elseif type(value) == "function"
        or type(value) == "thread"
        or type(value) == "userdata"
        or value == nil then
        print(spaces .. tostring(value))
    else
        print(spaces .. line_prefix .. "(" .. type(value) .. ") " .. tostring(value))
    end
end


a = { "header", 1, 2, 3, 4, 5, "tail"}
b = {
    name = "Mrvon",
    age = 18,
    subtable = a,
}

vardump(b)
