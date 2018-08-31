for i = 1, 10 do
    if i % 2 == 0 then
        goto CONTINUE
    end

    print("DEBUG i: " .. i)

    ::CONTINUE::
end

for j = 1, 10 do
    if j % 2 ~= 0 then
        goto CONTINUE
    end

    print("DEBUG j: " .. j)

    ::CONTINUE::
end
