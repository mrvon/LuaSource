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

print(quote("[===[hello world [[Nest]] ]===]"))
