local PREFIX_SIZE = 5

math.randomseed(os.time())

function allwords()
    local line = io.read()                             -- current line
    local pos = 1                                      -- current position in the line
    return function()                                  -- iterator function
        while line do                                  -- repeat while there are lines
            local s, e = string.find(line, "%w+", pos)
            if s then                                  -- found a word?
                pos = e + 1                            -- update next position
                return string.sub(line, s, e)          -- return the word
            else
                line = io.read()                       -- word not found; try next line
                pos = 1                                -- restart from first postion
            end
        end
        return nil
    end
end

function prefix(list)
    return table.concat(list, " ")
end

local statetab = {}

function insert(index, value)
    local list = statetab[index]
    if list == nil then
        statetab[index] = {value}
    else
        list[#list + 1] = value
    end
end

local MAXGEN = 10000
local NOWORD = "\n"

-- build table
local pre_list = {}
for i = 1, PREFIX_SIZE do
    table.insert(pre_list, NOWORD)
end

for w in allwords() do
    insert(prefix(pre_list), w)
    table.remove(pre_list, 1)
    table.insert(pre_list, w)
end
insert(prefix(pre_list), NOWORD)

-- generate text
local pre_list = {}
for i = 1, PREFIX_SIZE do
    table.insert(pre_list, NOWORD)
end

for i = 1, MAXGEN do
    local list = statetab[prefix(pre_list)]
    -- choose a ramdom item from list
    local r = math.random(#list)
    local nextword = list[r]
    if nextword == NOWORD then
        return
    end
    io.write(nextword, " ")
    table.remove(pre_list, 1)
    table.insert(pre_list, nextword)
end
