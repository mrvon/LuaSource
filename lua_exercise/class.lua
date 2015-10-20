function my_print(str, deep)
    print(string.rep(" ", deep * 9) .. str)
end

function clone(object)
    local lookup_table = {}
    local function __copy(object, deep)
        if type(object) ~= "table" then
            my_print("Case 1: " .. tostring(object), deep)
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
    local super_type = type(super)
    local sub_class

    if super_type ~= "function" and super_type ~= "table" then
        super_type = nil
        super = nil
    end

    if super_type == "function" or (super and super.__ctype == 1) then

        -- super is C++ object
        
        sub_class = {}

        if super_type == "table" then
            -- copy fields from super
            for key, value in pairs(super) do
                sub_class[key] = value
            end
            sub_class.__create = super.__create
            sub_class.super = super
        else
            sub_class.__create = super
        end

        sub_class.ctor = function() end
        sub_class.__cname = class_name
        sub_class.__ctype = 1

        function sub_class.new(...)
            local instance = sub_class.__create(...)
            -- copy fields from class to native object
            for key, value in pairs(sub_class) do
                instance[key] = value
            end
            instance.class = sub_class
            instance.ctor(instance, ...)
            return instance
        end
    else
        
        -- super is Lua object

        if super then
            sub_class = clone(super)
            sub_class.super = super
        else
            sub_class = {
                ctor = function() end
            }
        end

        sub_class.__cname = class_name
        sub_class.__ctype = 2
        sub_class.__index = sub_class

        function sub_class.new(...)
            local instance = setmetatable({}, sub_class)
            instance.class = sub_class
            instance.ctor(instance, ...)
            return instance
        end
    end

    return sub_class
end


local Animal = class("Animal", nil)

function Animal:ctor(name)
    self.name = name

    print(string.format("Animal:ctor(Name=%s)", self.name))
end

function Animal:say()
    print("I am a Animal")
end

local s = Animal.new("animal_1")
assert(s.class == Animal)
assert(s.ctor == Animal.ctor)
assert(s.__cname == Animal.__cname)
assert(s.__ctype == Animal.__ctype)

local Tiger = class("Tiger", Animal)
local t = Tiger.new("tiger_1")

function Tiger:ctor(name, power)
    Tiger.super.ctor(self, name)
    self.power = power

    print(string.format("Tiger:ctor(Name=%s, Power=%d)", self.name, self.power))
end


local t2 = Tiger.new("tiger_2", 100)
t2.say()

-- Override Animal:say()
function Tiger:say()
    print("I am a Tiger")
end

t2.say()
