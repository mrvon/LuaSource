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
