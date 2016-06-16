function allwords(f)
    for line in io.lines() do
        for word in string.gmatch(line, "%w+") do
            f(word)
        end
    end
end

allwords(print)


local count = 0
allwords(function(w)
    if w == "hello" then
        count = count + 1
    end
end)
print(count)

