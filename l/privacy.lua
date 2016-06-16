function newAccount(initialBalance, initialLimit)
    local self = {
        balance = initialBalance,
        limit = initialLimit,
    }
    local withdraw = function(v)
        self.balance = self.balance - v
    end
    local deposit = function(v)
        self.balance = self.balance + v
    end
    local extra = function()
        if self.balance > self.limit then
            return self.balance * 0.10
        else
            return 0
        end
    end
    local getBalance = function()
        return self.balance + extra()
    end
    return {
        withdraw = withdraw,
        deposit = deposit,
        getBalance = getBalance,
    }
end

acc1 = newAccount(100.00, 10000.00)
acc1.withdraw(40.00)
print(acc1.getBalance())
