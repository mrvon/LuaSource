List = {}

function List.new()
    return {first = 0, last = -1}
end

function List.pushfirst(list, value)
    local first = list.first - 1
    list.first = first
    list[first] = value
end

function List.pushlast(list, value)
    local last = list.last + 1
    list.last = last
    list[last] = value
end

function List.popfirst(list)
    local first = list.first
    if first > list.last then
        error("list is empty")
    end
    local value = list[first]
    list[first] = nil   -- to allow garbage collection
    list.first = first + 1

    List.__fix_index(list)
    return value
end

function List.poplast(list)
    local last = list.last
    if list.first > last then
        error("list is empty")
    end
    local value = list[last]
    list[last] = nil    -- to allow garbage collection
    list.last = last - 1

    List.__fix_index(list)
    return value
end

function List.getfirst(list)
    return list[list.first]
end

function List.getlast(list)
    return list[list.last]
end

function List.isempty(list)
    if list.first > list.last then
        return true
    else
        return false
    end
end

function List.__fix_index(list)
    if list.first > list.last then
        list.first = 0
        list.last = -1
    end
end

--------------------------------------------------------------------------------

local function debug(list)
    print(string.format("FI:%d LI:%d", list.first, list.last))
end


local function traverse(list)
    while true do
        local val = List.getfirst(list)
        if val == nil then
            break
        end
        List.popfirst(list)

        print(val)
    end
end

l = List.new()

List.pushfirst(l, "Hello ")
List.pushfirst(l, "Debug ")
List.pushlast(l, "World")
List.pushlast(l, "!")

traverse(l)
