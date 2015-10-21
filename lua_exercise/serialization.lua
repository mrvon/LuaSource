function mywrite(out_arr, ...)
    local t = {...}
    for i = 1, #t do
        table.insert(out_arr, t[i])
    end
end

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

function quote(s)
    -- find maximum length of sequence of equal signs
    local n = -1
    for w in string.gmatch(s, "]=*]") do
        n = math.max(n, #w - 2) -- -2 to remove the ']'s
    end

    -- produce a string with 'n' plus one equal signs
    local eq = string.rep("=", n + 1)

    -- build quoted string
    return string.format("[%s[%s]%s]", eq, s, eq)
end
-- print(quote("[===[hello world [[Nest]] ]===]"))

function indent(out_arr, indent_level)
    for i = 1, indent_level do
        mywrite(out_arr, "\t")
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
        indent(out_arr, indent_level)
        for k, v in pairs(o) do
            if not isvalidindentfier(k) then
                mywrite(out_arr, "  [")
                aux_serialize(out_arr, k, indent_level + 1)
                mywrite(out_arr, "] = ")
            else
                mywrite(out_arr, "  " .. k .. " = ")
            end
            aux_serialize(out_arr, v, indent_level + 1)
            mywrite(out_arr, ",\n")
            indent(out_arr, indent_level)
        end
        mywrite(out_arr, "}\n")
        indent(out_arr, indent_level)
    else
        error("cannot serialize a " .. type(o))
    end
end


print(serialize({a = 12, b = 'lua', key = 'another "one"', "hello world"}))
print(serialize({[1] = 12, [2] = 'lua', [3] = 'another "one"'}))
print(serialize({["1a"] = 12, ["1b"] = 'lua', ["1c"] = 'another "one"'}))
print(serialize({["1a"] = {nest_str = "Hello world", {nest_str = "Hi!"}}, ["1b"] = 'lua', ["1c"] = 'another "one"'}))

function basic_serialize(o)
    if type(o) == "number" then
        return tostring(o)
    elseif type(o) == "string" then
        return string.format("%q", o)
    else
        error("basic serialize failed")
    end
end

function save(name, value, saved)
    local out_arr = {}
    aux_save(out_arr, name, value, saved)
    return table.concat(out_arr)
end

function aux_save(out_arr, name, value, saved)
    saved = saved or {}                                        -- initial value
    mywrite(out_arr, name, " = ")
    if type(value) == "number" or type(value) == "string" then
        mywrite(out_arr, basic_serialize(value), "\n")
    elseif type(value) == "table" then
        if saved[value] then                                   -- value already saved?
            mywrite(out_arr, saved[value], "\n")               -- use its previous name
        else
            saved[value] = name                                -- save name for next time
            mywrite(out_arr, "{}\n")                           -- create a new table
            for k, v in pairs(value) do                        -- save its fields
                k = basic_serialize(k)
                local fname = string.format("%s[%s]", name, k)
                aux_save(out_arr, fname, v, saved)
            end
        end
    else
        error("cannot save a " .. type(value))
    end
end

-- local t = {}
-- a = {{"one", "two"}, 3}
-- b = {k = a[1]}
-- print(save("a", a, t))
-- print(save("b", b, t))

