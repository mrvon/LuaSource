Account = {balance = 0}

function Account:new(o)
    o  = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Account:deposit(v)
    self.balance = self.balance + v
end

function Account:withdraw(v)
    if v > self.balance then
        error ("insufficient funds")
    end
    self.balance = self.balance - v
end

function Account:detail()
    print(string.format("Balance: %d", self.balance))
end

SpecialAccount = Account:new()
function SpecialAccount:withdraw(v)
    if v - self.balance >= self:getLimit() then
        error("insufficient funds")
    end
    self.balance = self.balance - v
end

function SpecialAccount:getLimit()
    return self.limit or 0
end

-- s = SpecialAccount:new({limit = 1000.00})
-- s:deposit(100)
-- s:detail()
-- s:withdraw(900)
-- s:detail()


Named = {}

function Named:getname()
    return self.name
end

function Named:setname(n)
    self.name = n
end

-- look up for 'k' in list of tables 'plist'
local function search(k, plist)
    for i = 1, #plist do
        local v = plist[i][k]
        if v then
            return v
        end
    end
end

function createClass(...)
    local c = {} -- new class
    local parents = {...}

    -- class with search for each method in the list of its parents
    setmetatable(c, {
        __index = function(t, k)
            return search(k, parents)
        end
    })
    
    -- prepare 'c' to be the metatable of its instance
    c.__index = c

    -- define a new constructor for this new class
    function c:new(o)
        o = o or {}
        setmetatable(o, c)
        return o
    end

    return c -- return new class
end

NamedAccount = createClass(Account, Named)
account = NamedAccount:new({name = "Paul"})
print(account:getname())
account:detail()
