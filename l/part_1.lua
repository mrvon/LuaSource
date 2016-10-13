f = string.find
a = {"hello", "ll"}
print(f(table.unpack(a)))

t = {"Sun", nil, nil, "Mon", "Tue", "Wed", nil}
print(table.unpack(t))
print(table.unpack(t, 1, 5))

function raw_unpack(t, i, n)
    if i <= n then
        return t[i], raw_unpack(t, i+1, n)
    end
end

function wrap_unpack(t)
    return raw_unpack(t, 1, #t)
end

s = {"Sun", "Mon", "Tue", "Wed"}
print(wrap_unpack(s))
print(wrap_unpack(t))
print(raw_unpack(t, 1, 5))

function nonils(...)
    local arg = table.pack(...)
    for i = 1, arg.n do
        if arg[i] == nil then
            return false
        end
    end
    return true
end

function wrong_nonils(...)
    local arg = table.pack(...)
    for i = 1, #arg do
        if arg[i] == nil then
            return false
        end
    end
    return true
end

print(nonils(2, 3, nil))
print(nonils(2, 3))
print(nonils())
print(nonils(nil))

print(wrong_nonils(2, 3, nil))
print(wrong_nonils(2, 3))
print(wrong_nonils())
print(wrong_nonils(nil))

function concat(...)
    local arg = {...}
    local res = ""
    for i = 1, #arg do
        res = res .. arg[i]
    end
    return res
end

print(concat("Hello", "World", "!"))

print(table.unpack(s))

function remove_first(...)
    local arg = table.pack(...)
    return table.unpack(arg, 2, arg.n)
end

print(remove_first(table.unpack(s)))

-- print("-----------------------------------------------")
-- i = 32
-- local i = 0
-- f = load("i = i + 1; print(i)")
-- g = function() i = i + 1 ; print(i) end
-- f()
-- g()

-- print("enter you expression:")
-- local l = io.read()
-- local func = assert(load("return " .. l))
-- print("the value of your expression is: " .. func())

-- print("-----------------------------------------------")
-- print("enter function to be plotted (with variable 'x')")
-- local l = io.read()
-- local f = assert(load("return " .. l))
-- for i = 1, 20 do
--     x = i -- global 'x' (to be visible from the chunk)
--     print(string.rep("*", f()))
-- end

-- print("-----------------------------------------------")
-- print("enter function to be plotted (with variable 'x'):")
-- local l = io.read()
-- local f = assert(load("local x = ...; return " .. l))
-- for i = 1, 20 do
--     print(string.rep("*", f(i)))
-- end

-- print("-----------------------------------------------")
-- print("enter a number:")
-- n = io.read("*n")
-- if not n then
--     error("invalid input")
-- end
-- print("echo number:" .. n)
-- assert(io.read("*n"), "invalid input")

-- print("-----------------------------------------------")
-- local ok, msg = pcall(function() 
--     local i = 1
--     error({code = 121})
-- end)
-- if ok then
--     print("Ok! Msg: ")
-- else
--     print("No Ok! Msg: " .. msg.code)
-- end

-- print("-----------------------------------------------")
-- local ok, msg = pcall(
-- function ()
--     if type(str) ~= "string" then
--         error("string expected")
--     end
-- end, {x = 1})
-- if not ok then
--     print(msg)
-- end

-- print("-----------------------------------------------")
-- local reader_func = io.lines("test.lua", "*L")
-- for i = 1, 20 do
--     io.write(reader_func())
-- end

print("-----------------------------------------------")
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

local reader_func = io.lines("foo.lua", "*L")
loadwithprefix("return ", "1 + 2")
loadwithprefix("return ", reader_func)


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

load_multiload_func("local x = 10;", io.lines("goo.lua", "*L"), " print(x)")

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
