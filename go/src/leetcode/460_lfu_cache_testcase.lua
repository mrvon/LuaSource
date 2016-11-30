--[[
$ cat 460_lfu_cache_testcase | lua 460_lfu_cache_testcase.lua > 460_lfu_cache_test.h
]]

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
            return arg
        elseif cmd == "set" then
            return string.match(arg, "(.+),(.+)")
        else
            return arg
        end
    end
end

local function generate(cmd_line, arg_line, test_case)
    local cr = cmd_reader(cmd_line)
    local ar = arg_reader(arg_line)

    print(string.format("void test_%d() {", test_case))
    while true do
        local cmd = cr()
        if cmd == nil then
            break
        end

        if cmd == "get" then
            print(string.format("lFUCacheGet(obj, %s);", ar(cmd)))
        elseif cmd == "set" then
            print(string.format("lFUCacheSet(obj, %s, %s);", ar(cmd)))
        else
            print(string.format("const int capacity = %d;\nLFUCache* obj = lFUCacheCreate(capacity);", ar(cmd)))
        end
    end
    print("}")
end

local case = {
}

for line in io.lines() do
    table.insert(case, line)
end

local test_case = 1

while true do
    if #case >= 2 then
        -- RUN TEST
        local cmd_line = case[#case-1]
        local arg_line = case[#case]
        table.remove(case, #case)
        table.remove(case, #case)

        generate(cmd_line, arg_line, test_case)
        test_case = test_case + 1
    else
        break
    end
end

print("int main() {")
for i = 1, test_case-1 do
    print(string.format("test_%d();", i))
end
print("}")
