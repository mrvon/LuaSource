local function permgen(a, n)
    n = n or #a

    if n == 1 then
        coroutine.yield(a)
    else
        for i = 1, n do
            a[i], a[n] = a[n], a[i]
            permgen(a, n - 1)
            a[i], a[n] = a[n], a[i]
        end
    end
end

local function permutations(a)
    local co = coroutine.create(permgen)
    return function()
        local status, value = coroutine.resume(co, a)
        return value
    end
end

local function print_permutation(a)
    for i = 1, #a do
        io.write(a[i] .. " ")
    end
    io.write("\n")
end

local N = 8

-- check whether position (n, c) is free from attacks
local function isplaceok(a, n, c)
    for i =  1, n - 1 do
        if (a[i] == c) or               -- same column?
            (a[i] - i == c - n) or      -- same diagonal?
            (a[i] + i == c + n) then    -- same diagonal?
            return false                -- place can be attcked
        end
    end

    return true
end

-- print a broad
local function printsolution(a)
    for i = 1, N do
        for j = 1, N do
            io.write(a[i] == j and "X" or "-", " ")
        end
        io.write("\n")
    end
    io.write("\n")
end

local function print_permutation(a)
    for i = 1, #a do
        io.write(a[i] .. " ")
    end
    io.write("\n")
end

for a in permutations({1, 2, 3, 4, 5, 6, 7, 8}) do
    local is_ok = true
    for i = 1, #a do
        if not isplaceok(a, i, a[i]) then
            is_ok = false
            break
        end
    end

    if is_ok then
        printsolution(a)
    end
end
