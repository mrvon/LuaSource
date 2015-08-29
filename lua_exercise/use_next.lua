t = {
    "hello",
    "world",
    k = "k",
}

function pairs_traversal(t)
    local k = nil
    local v = nil
    while true do
        k, v = next(t, k)
        if k == nil then
            break
        end
        print(k, v)
    end
end

for k, v in pairs(t) do
    print(k, v)
end
