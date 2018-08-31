function my_dofile(filename)
    local f = assert(loadfile(filename))
    return f()
end

function my_dostring(s)
    assert(load(s))()
end

print("----------------------------------------------------------------------")

--[[
i = 32
local i = 0
f = load("i = i + 1; print(i)")
g = function() i = i + 1 ; print(i) end
f()
g()
]]

print("----------------------------------------------------------------------")

--[[
print("enter you expression:")
local l = io.read()
local func = assert(load("return " .. l))
print("the value of your expression is: " .. func())
]]

print("----------------------------------------------------------------------")

--[[
print("enter function to be plotted (with variable 'x')")
local l = io.read()
local f = assert(load("return " .. l))
for i = 1, 20 do
    x = i -- global 'x' (to be visible from the chunk)
    print(string.rep("*", f()))
end
]]

print("----------------------------------------------------------------------")

--[[
print("enter function to be plotted (with variable 'x'):")
local l = io.read()
local f = assert(load("local x = ...; return " .. l))
for i = 1, 20 do
    print(string.rep("*", f(i)))
end
]]

print("----------------------------------------------------------------------")

-- print("enter a number:")
-- n = io.read("*n")
-- if not n then
--     error("invalid input")
-- end
-- print("echo number:" .. n)
-- assert(io.read("*n"), "invalid input")

print("----------------------------------------------------------------------")

--[[
local ok, msg = pcall(function() 
    local i = 1
    error({code = 121})
end)
if ok then
    print("Ok! Msg: ")
else
    print("No Ok! Msg: " .. msg.code)
end
]]

print("----------------------------------------------------------------------")

--[[
local ok, msg = pcall(
function (t)
    if type(t.x) ~= "string" then
        error("string expected")
    end
end, {x = 1})
if not ok then
    print(msg)
end
]]

print("----------------------------------------------------------------------")

--[[
We can call the *load* function also with a *reader* function as its first
argument. A reader function can return the chunk in parts; *load* calls the
reader successively until it returns nil, which signals the chunk's end.
]]

function my_loadfile(filename)
    local f = load(io.lines(filename, "*L"))
    return f
end


local reader_func = io.lines("compilation.lua", "*L")
for i = 1, 5 do
    io.write(reader_func())
end

print("----------------------------------------------------------------------")

local rd_func = (function()
    local code = {
        'local f = "Fuck',
        '"print(f)',
        'print("world")',
        'print("world")',
    }
    local index = 0

    return function()
        index = index + 1
        if index > #code then
            return nil
        else
            return code[index]
        end
    end
end)()

my_dostring(rd_func)

print("----------------------------------------------------------------------")
print("Solution Exercise 8.1")

function make_reader_function(prefix, reader_func)
    local first_tag = true
    return function()
        if first_tag then
            first_tag = false
            return prefix
        else
            return reader_func()
        end
    end
end

function make_string_reader_function(...)
    local arg = table.pack(...)
    local i = 0
    return function()
        i = i + 1
        return arg[i]
    end
end

function loadwithprefix(prefix, arg)
    if type(arg) == "string" then
        local rf = make_string_reader_function(prefix, arg)
        local f = assert(load(rf))
        print(f())
    elseif type(arg) == "function" then
        local rf = make_reader_function(prefix, arg)
        local f = assert(load(rf))
        print(f())
    else
        error("wrong type!")
    end
end

local reader_func = io.lines("compilation_input_1.lua", "*L")
loadwithprefix("return ", "1 + 2")
loadwithprefix("return ", reader_func)


print("----------------------------------------------------------------------")
print("Solution Exercise 8.2")

function make_multiload_reader_func(...)
    local arg = table.pack(...)
    local i = 1
    local cache = nil
    return function()
        local a = arg[i]
        if type(a) == "string" then
            i = i + 1
            return a
        elseif type(a) == "function" then
            local r
            if cache then
                r = cache
                cache = nil
            else
                r = a()
            end

            cache = a()
            if cache == nil then
                i = i + 1
            end
            return r
        end
    end
end

function load_multiload_func(...)
    local mf = assert(load(make_multiload_reader_func(...)))
    mf()
end

load_multiload_func("local x = 10;", io.lines("compilation_input_2.lua", "*L"), " print(x)")

print("----------------------------------------------------------------------")
print("Solution Exercise 8.3")

function stringrep_5(s)
    local r = ""
    r = r .. s
    s = s .. s
    s = s .. s
    r = r .. s 
    return r
end

function stringrep(s, n)
    local r = ""
    if n > 0 then
        while n > 1 do
            if n % 2 ~= 0 then
                r = r .. s
            end
            s = s .. s
            n = math.floor(n / 2)
        end
        r = r .. s
    end
    return r
end

print(stringrep_5("*"))
print(stringrep("*", 10))

function make_stringrep_n_list(n)
    local list = {}
    list[#list + 1] = "local r = \"\" "
    list[#list + 1] = "local s = ... "
    if n > 0 then
        while n > 1 do
            if n % 2 ~= 0 then
                list[#list + 1] = "r = r .. s "
            end
            list[#list + 1] = "s = s .. s "
            n = math.floor(n / 2)
        end
        list[#list + 1] = "r = r .. s "
    end
    list[#list + 1] = "return r "
    return list
end

function make_stringrep_n_reader_func(n)
    local instruction_list = make_stringrep_n_list(n)
    local i = 0
    return function()
        i = i + 1
        return instruction_list[i]
    end
end

function make_stringrep_n_func(n)
    local f = assert(load(make_stringrep_n_reader_func(n)))
    return f
end

local stringrep_4 = make_stringrep_n_func(4)
print(stringrep_4("+"))

print("----------------------------------------------------------------------")
print("Solution Exercise 8.4")

function pf()
    error("error!")
end
local ok, msg = pcall(pcall, pf)
if ok then
    print("Ok!")
else
    print("No Ok!")
end

