--[[
Design table without recycle, 
I try to forbid use a not empty table as a value when set table
we will implement UsrData.empty in c code, it will be very fast,
instead of call pairs()
]]

local UsrData = {}
function UsrData.empty(t)
    for _, _ in pairs(t) do
        return false
    end
    return true
end

function UsrData.new()
    local ud = {}
    setmetatable(ud, {
        __newindex = function(t, k, v)
            if type(v) == "table" then
                if not UsrData.empty(t) then
                    error("cannot use not empty table")
                end
            elseif type(v) == "thread" or
                type(v) == "userdata" then
                error("serialization system donot support type")
            end
            rawset(t, k, v)
        end
    })
    return ud
end

local a = UsrData.new()
a[1] = 1
a[2] = 2
a[3] = 3
a[4] = 4

local b = UsrData.new()
b.name = "Mrvon"
b.age = 18
b.sin = math.sin

b.subtable = a

