-- Shared upvalue
function create_shared_upvalue_closure(x)
    local f1 = function()
        x = x + 1
        return x
    end

    local f2 = function()
        x = x + 1
        return x
    end

    return f1, f2
end

local f1, f2 = create_shared_upvalue_closure(0)
print(string.format("F1: %d", f1()))
print(string.format("F1: %d", f1()))
print(string.format("F2: %d", f2()))
print(string.format("F2: %d", f2()))

--------------------------------------------------------------------------------
--[[
    Access an outer local variable that does not 
    belong to its immediately enclosing function
]]

function create_closure_builder(x)
    return function()
        return function()
            x = x + 1
            return x
        end
    end
end

local bf3 = create_closure_builder(0)
local f3 = bf3()
print(string.format("F3: %d", f3()))
print(string.format("F3: %d", f3()))
