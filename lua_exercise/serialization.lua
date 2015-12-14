function isvalidindentfier(k)
    local pattern = "[_%a][_%a%d]*"
    local str = string.match(k, pattern)
    if k == str then
        return true
    else
        return false
    end
end
assert(isvalidindentfier("a"))
assert(isvalidindentfier("a1"))
assert(isvalidindentfier("_a1"))
assert(isvalidindentfier("__a1"))
assert(isvalidindentfier("__1"))
assert(isvalidindentfier("__abc"))
assert(isvalidindentfier("__ab1c3"))
assert(not isvalidindentfier("1a"))
assert(not isvalidindentfier("$a"))


function indent(out_arr, indent_level)
    for i = 1, indent_level do
        mywrite(out_arr, "\t")
    end
end

function mywrite(out_arr, ...)
    local t = {...}
    for i = 1, #t do
        table.insert(out_arr, t[i])
    end
end

function serialize(o)
    local out_arr = {}
    aux_serialize(out_arr, o)
    return table.concat(out_arr)
end

function aux_serialize(out_arr, o, indent_level)
    indent_level = indent_level or 0
    if type(o) == "number" then
        mywrite(out_arr, o)
    elseif type(o) == "string" then
        mywrite(out_arr, string.format("%q", o))
    elseif type(o) == "table" then
        mywrite(out_arr, "{\n")
        for k, v in pairs(o) do
            indent(out_arr, indent_level + 1)
            if not isvalidindentfier(k) then
                mywrite(out_arr, "[")
                aux_serialize(out_arr, k, indent_level + 1)
                mywrite(out_arr, "] = ")
            else
                mywrite(out_arr, k .. " = ")
            end

            aux_serialize(out_arr, v, indent_level + 1)

            if type(v) ~= "table" then
                mywrite(out_arr, ",\n")
            end
        end
        indent(out_arr, indent_level)
        mywrite(out_arr, "},\n")
    else
        error("cannot serialize a " .. type(o))
    end
end


print(serialize({a = 12, b = 'lua', key = 'another "one"', "hello world"}))
print(serialize({[1] = 12, [2] = 'lua', [3] = 'another "one"'}))
print(serialize({["1a"] = 12, ["1b"] = 'lua', ["1c"] = 'another "one"'}))
print(serialize({["1a"] = {nest_str = "Hello world", {nest_str = "Hi!", nest_str_2 = "World"}}, ["1b"] = 'lua', ["1c"] = 'another "one"'}))

--------------------------------------------------------------------------------
-- serialize support loop and share

function base_seri(o)
    if type(o) == "number" then
        return tostring(o)
    elseif type(o) == "string" then
        return string.format("%q", o)
    else
        error("basic serialize failed")
    end
end

function loop_seri(name, value, saved)
    local out_arr = {}
    aux_loop_seri(out_arr, name, value, saved)
    return table.concat(out_arr)
end

function aux_loop_seri(out_arr, name, value, saved)
    saved = saved or {}                                        -- initial value
    mywrite(out_arr, name, " = ")
    if type(value) == "number" or type(value) == "string" then
        mywrite(out_arr, base_seri(value), "\n")
    elseif type(value) == "table" then
        if saved[value] then                                   -- value already saved?
            mywrite(out_arr, saved[value], "\n")               -- use its previous name
        else
            saved[value] = name                                -- save name for next time
            mywrite(out_arr, "{}\n")                           -- create a new table
            for k, v in pairs(value) do                        -- save its fields
                k = base_seri(k)
                local fname = string.format("%s[%s]", name, k)
                aux_loop_seri(out_arr, fname, v, saved)
            end
        end
    else
        error("cannot save a " .. type(value))
    end
end


-- table with loop
local loop_t = {
    Name = "Dennis",
    Age = 18,
    Phone = {
        type = 1,
        number = "123",
    }
}
loop_t.self = loop_t

-- print(loop_seri("loop_t", loop_t))

function seri(seri_table)
    return "do local " .. loop_seri("ret", seri_table) .. "return ret end"
end

function unseri(seri_str)
    local f = load(seri_str)
    if f then
        return f()
    end
end

local s = seri(loop_t)
local t = unseri(s)

for k, v in pairs(loop_t) do
    print(k, v)
end

for k, v in pairs(t) do
    print(k, v)
end

--------------------------------------------------------------------------------

-- share
local share_t = {}

local share_1 = {
    name = "share_1",
    type = 1,
}
share_1.self = share_1

local share_2 = {
    name = "share_2",
    type = 2,
}
share_2.self = share_2

share_1.ref = share_2
share_2.ref = share_1

print(loop_seri(share_1.name, share_1, share_t))
print(loop_seri(share_2.name, share_2, share_t))
