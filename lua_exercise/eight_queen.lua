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

-- add to board 'a' all queens from 'n' to 'N'
local function addqueen(a, n)
    if n > N then   -- all queens have been palced?
        printsolution(a)
        coroutine.yield()
    else    -- try to place n-th queen
        for c = 1, N do
            if isplaceok(a, n, c) then
                a[n] = c    -- place n-th queen at column 'c'
                addqueen(a, n + 1)
            end
        end
    end
end

-- run the program
local co = coroutine.create(addqueen)
coroutine.resume(co, {}, 1)
