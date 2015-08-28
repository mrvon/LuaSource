local dict = {
    "one",
    "two",
    "three",
}

local function my_iter(a, i)
    i = i + 1
    local v = a[i]
    if v then
        return i, v
    end
end

local function my_ipairs(a)
    return my_iter, a, 0
end

local function my_pairs(t)
    return next, t, nil
end

for i, v in my_ipairs(dict) do
    print(i, v)
end

for k, v in my_pairs(dict) do
    print(k, v)
end

for k, v in next, dict do
    print(k, v)
end
