-- Exercise 7.1
function fromto(min, max)
    return iter, max, min - 1
end

function iter(max, cur)
    if cur + 1 <= max then
        return cur + 1
    end
end

-- Exercise 7.2
function ex_fromto(min, max, step)
    local state = {
        max = max,
        step = step,
    }
    return ex_iter, state, min - 1
end

function ex_iter(state, cur)
    if cur + state.step <= state.max then
        return cur + state.step
    end
end

local n = 1
local m = 10

for i in fromto(n, m) do
    print(i)
end

for i in ex_fromto(n, m, 3) do
    print(i)
end

-- Exercise 7.3
function uniquewords()
    local line = io.read()
    local pos = 1
    local dict = {}

    return function()
        while line do
            local s, e = string.find(line, "%w+", pos)
            if s then
                pos = e + 1
                local word = string.sub(line, s, e)
                if dict[word] == nil then
                    dict[word] = true
                    return word
                end
            else
                line = io.read()
                pos = 1
            end
        end
        return nil
    end
end

for word in uniquewords() do
    print(word)
end
