local WORD_MIN_LEN = 4

local function ignore_by_length(w)
    if #w >= WORD_MIN_LEN then
        return false
    else
        return true
    end
end

local function make_ignore_dict()
    local f = assert(io.open("ignore.txt", "r"))
    local text = f.read(f, "*a")
    if text == nil then
        print("read dict file failed")
        return
    end

    local dict = {}
    for word in string.gmatch(text, "%w+") do
        dict[word] = true
    end
    return dict
end

local ignore_dict = make_ignore_dict()

local function ignore_by_dict(w, dict)
    if dict[w] then
        return true
    else
        return false
    end
end

local function allwords()
    local auxwords = function()
        for line in io.lines() do
            for word in string.gmatch(line, "%w+") do
                coroutine.yield(word)
            end
        end
    end
    return coroutine.wrap(auxwords)
end

local counter = {}
for w in allwords() do
    if not ignore_by_dict(w, ignore_dict) then
        counter[w] = (counter[w] or 0) + 1
    end
end

local words = {}
for w in pairs(counter) do
    words[#words + 1] = w
end

table.sort(words, function(w1, w2) 
    return counter[w1] > counter[w2] or
        counter[w1] == counter[w2] and w1 < w2
end)

for i = 1, (tonumber(arg[1]) or 10) do
    print(words[i], counter[words[i]])
end
