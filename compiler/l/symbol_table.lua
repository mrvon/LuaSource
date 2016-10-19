local symbol_table = {} 

function symbol_table:insert(name, lineno, location)
    if self.data == nil then
        self.data = {}
    end
    local data = self.data

    if data[name] == nil then
        data[name] = {
            location = location
        }
    end

    local t = data[name]

    if t.lineno == nil then
        t.lineno = {}
    end
    table.insert(t.lineno, lineno)
end

function symbol_table:lookup(name)
    if self.data == nil then
        self.data = {}
    end
    local data = self.data

    local t = data[name]
    if t then
        return t.location
    end
end

function symbol_table:print()
    if self.data == nil then
        self.data = {}
    end
    local data = self.data

    print("Variable Name   Location   Line Numbers")
    print("-------------   --------   ------------")
    for name, t in pairs(data) do
        io.write(string.format("%-16s", name))
        io.write(string.format("%-11d", t.location))
        for _, lineno in pairs(t.lineno) do
            io.write(string.format("%-4d", lineno))
        end
        io.write("\n")
    end
    print("-------------   --------   ------------")
end

function symbol_table.new()
    return setmetatable({}, {
        __index = symbol_table
    })
end

return symbol_table
