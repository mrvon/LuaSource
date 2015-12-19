function insert_front_linked_list(list, val)
    local list = {next = list, value = val}
    return list
end

function traverse(list)
    local l = list
    while l do
        io.write(l.value)
        l = l.next
    end
end

local l = nil
local l = insert_front_linked_list(l, "!")
local l = insert_front_linked_list(l, "World")
local l = insert_front_linked_list(l, "Hello")
traverse(l)
io.write("\n")
