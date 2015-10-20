function my_print(str, deep)
    print(string.rep(" ", deep * 9) .. str)
end

function clone(object)
    local lookup_table = {}
    local function __copy(object, deep)
        if type(object) ~= "table" then
            my_print("Case 1: " .. object, deep)
            return object
        elseif lookup_table[object] then
            my_print("Case 2", deep)
            return lookup_table[object]
        end
        my_print("-------- Case 3 start --------", deep)
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[__copy(key, deep + 1)] = __copy(value, deep + 1)
        end
        my_print("-------- Case 3 end ----------", deep)
        return setmetatable(new_table, getmetatable(object))
    end
    return __copy(object, 0)
end

local base = {
    name = "Dennis",
    age = 21,
    sub = {
        name = "Von",
        sub2 = {
            name = "Von2",
        }
    },
}
base.self = base
base.sub.self = base.sub
base.sub.sub2.self = base.sub.sub2
base.sub.super = base
base.sub.sub2.super = base.sub

local rc = clone(base)
assert(rc.name == base.name)
assert(rc.age == base.age)
assert(rc.sub.name == base.sub.name)
assert(rc.sub.sub2.name == base.sub.sub2.name)


function class(class_name, super)
end
