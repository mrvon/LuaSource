local function cmd_reader(cmd_line)
    local pattern = "\"[^\"]+\""
    return function()
        local s, e = string.find(cmd_line, pattern)
        if s == nil then
            return
        end
        local cmd = string.sub(cmd_line, s+1, e-1)
        cmd_line = string.sub(cmd_line, e+1, -1)
        return cmd
    end
end

local function arg_reader(arg_line)
    local pattern = "%[[^%[%]]+%]"
    return function(cmd)
        local arg

        local s, e = string.find(arg_line, pattern)
        if s == nil then
            return
        end

        arg = string.sub(arg_line, s+1, e-1)
        arg_line = string.sub(arg_line, e+1, -1)

        if cmd == "get" then
            return string.match(arg, "(.+),(.+)")
        elseif cmd == "set" then
            return arg
        else
            return arg
        end
    end
end

local function generate(cmd_line, arg_line)
    local c = cmd_reader(cmd_line)
    local a = arg_reader(arg_line)
    print(a(""))
    print(a("get"))
    print(a("get"))
    print(a("get"))
    print(a("set"))
end

local case = {
}

for line in io.lines() do
    table.insert(case, line)
end

while true do
    if #case >= 2 then
        -- RUN TEST
        local cmd_line = case[#case-1]
        local arg_line = case[#case]
        table.remove(case, #case)
        table.remove(case, #case)

        generate(cmd_line, arg_line)
    else
        break
    end
end
