function permgen(a, k, n)
    k = k or 1
    n = n or #a

    if n <= 1 then
        printResult(a)
    else
        for i = 0, n - 1 do
            a[k + i], a[k] = a[k], a[k + i]
            permgen(a, k + 1, n - 1)
            a[k + i], a[k] = a[k], a[k + i]
        end
    end
end

function printResult(a)
    for i = 1, #a do
        io.write(a[i], " ")
    end
    io.write("\n")
end

-- permgen({1, 2, 3, 4})

function permutations(a)
    local co = coroutine.create(function () permgen(a) end)
    return function () -- iterator
        local code, res = coroutine.resume(co)
        return res
    end
end

function permutations(a)
    return coroutine.wrap(function () permgen(a) end)
end

for p in permutations{"a", "b", "c"} do
    printResult(p)
end
