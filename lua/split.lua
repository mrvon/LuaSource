local StringLib = {}

function StringLib.split(str, sep)
    local res = {}
    local l
    while true do
        local b, e = string.find(str, sep)
        if b == nil then
            break
        end
        l = e
        res[#res + 1] = string.sub(str, 1, b - 1)
        str = string.sub(str, e + 1)
    end
    res[#res + 1] = str
    return res
end

return StringLib
