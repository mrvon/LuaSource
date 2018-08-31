List = {}

function List.new()
    local mt = {
        __index = List
    }
    return setmetatable({
        first = 0,
        last = -1,
    }, mt)
end

function List:pushfirst(value)
    local first = self.first - 1
    self.first = first
    self[first] = value
end

function List:pushlast(value)
    local last = self.last + 1
    self.last = last
    self[last] = value
end

function List:popfirst()
    local first = self.first
    if first > self.last then
        error("list is empty")
    end
    local value = self[first]
    self[first] = nil   -- to allow garbage collection
    self.first = first + 1

    self:__fix_index()
    return value
end

function List:poplast()
    local last = self.last
    if self.first > last then
        error("list is empty")
    end
    local value = self[last]
    self[last] = nil    -- to allow garbage collection
    self.last = last - 1

    self:__fix_index()
    return value
end

function List:getfirst()
    return self[self.first]
end

function List:getlast()
    return self[self.last]
end

function List:__fix_index()
    if self.first > self.last then
        self.first = 0
        self.last = -1
    end
end

--------------------------------------------------------------------------------

local function debug(list)
    print(string.format("FI:%d LI:%d", list.first, list.last))
end


local function traverse(list)
    while true do
        local val = list:getfirst()
        if val == nil then
            break
        end
        list:popfirst()

        print(val)
    end
end

l = List.new()

l:pushfirst("Hello")
l:pushfirst("Debug")
l:pushlast("World")
l:pushlast("!")

traverse(l)
