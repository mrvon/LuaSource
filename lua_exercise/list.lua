List = {}

function List.new()
    return {first = 0, last = -1}
end

function List.Debug(list)
    print(string.format("FI:%d LI:%d", list.first, list.last))
end

function List.FixIndex(list)
    if list.first > list.last then
        list.first = 0
        list.last = -1
    end
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

    List.FixIndex(list)
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

    List.FixIndex(list)
    return value
end

function List.traverse(list)
    local first = list.first
    local last = list.last
    while first <= last do
        print(list[first])
        first = first + 1
    end
end

l = List.new()
List.pushfirst(l, "Hello ")
List.pushfirst(l, "Debug ")
List.pushlast(l, "World")
List.pushlast(l, "!")
List.traverse(l)
List.popfirst(l)
List.poplast(l)
List.poplast(l)
List.poplast(l)
List.Debug(l)
