-- Fisher–Yates_shuffle
--
-- To shuffle an array a of n elements (indices 0..n-1):
--
-- for i from n−1 downto 1 do
--      j ← random integer such that 0 ≤ j ≤ i
--      exchange a[j] and a[i]

math.randomseed(os.time())

function random_shuffle(list)
    local count = #list
    local i = count
    while i > 1 do
        local rand = math.random(i)
        local temp = list[i]
        list[i] = list[rand]
        list[rand] = temp
        i = i - 1
    end
end

function print_list(l)
    for i = 1, #l do
        io.write(l[i])
        io.write(" ")
    end
    io.write("\n")
end

local l = {1, 2, 3, 4}
while true do
    random_shuffle(l)
    print_list(l)
end
