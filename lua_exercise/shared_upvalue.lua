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
