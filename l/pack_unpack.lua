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
