package.cpath = "luaclib/?.so"
package.path = "lualib/?.lua"

local crypt = require "crypt"
local parser = require "sprotoparser"
local sproto = require "sproto.core"

function cclog(obj)  
    local getIndent, quoteStr, wrapKey, wrapVal, isArray, dumpObj  
    getIndent = function(level)  
        return string.rep("\t", level)  
    end  
    quoteStr = function(str)  
        str = string.gsub(str, "[%c\\\"]", {  
            ["\t"] = "\\t",  
            ["\r"] = "\\r",  
            ["\n"] = "\\n",  
            ["\""] = "\\\"",  
            ["\\"] = "\\\\",  
        })  
        return '"' .. str .. '"'  
    end  
    wrapKey = function(val)  
        if type(val) == "number" then  
            return "[" .. val .. "]"  
        elseif type(val) == "string" then  
            return "[" .. quoteStr(val) .. "]"  
        else  
            return "[" .. tostring(val) .. "]"  
        end  
    end  
    wrapVal = function(val, level)  
        if type(val) == "table" then  
            return dumpObj(val, level)  
        elseif type(val) == "number" then  
            return val  
        elseif type(val) == "string" then  
            return quoteStr(val)  
        else  
            return tostring(val)  
        end  
    end  
    local isArray = function(arr)  
        local count = 0   
        for k, v in pairs(arr) do  
            count = count + 1   
        end   
        for i = 1, count do  
            if arr[i] == nil then  
                return false  
            end   
        end   
        return true, count  
    end  
    dumpObj = function(obj, level)  
        if type(obj) ~= "table" then  
            return wrapVal(obj)  
        end  
        level = level + 1  
        local tokens = {}  
        tokens[#tokens + 1] = "{"  
        local ret, count = isArray(obj)  
        if ret then  
            for i = 1, count do  
                tokens[#tokens + 1] = getIndent(level) .. wrapVal(obj[i], level) .. ","  
            end  
        else  
            for k, v in pairs(obj) do  
                tokens[#tokens + 1] = getIndent(level) .. wrapKey(k) .. " = " .. wrapVal(v, level) .. ","  
            end  
        end  
        tokens[#tokens + 1] = getIndent(level - 1) .. "}"  
        return table.concat(tokens, "\n")  
    end  
    return dumpObj(obj, 0)  
end

local schema = [[
.Person {
    name 0 : string
    id 1 : integer
    email 2 : string

    .PhoneNumber {
        number 0 : string
        type 1 : integer
    }

    phone 3 : *PhoneNumber
}

.AddressBook {
    person 0 : *Person
}
]]

local packet = {
    person = {
        {
            name = "Alice",
            id = 10000,
            phone = {
                { number = "123456789" , type = 1 },
                { number = "87654321" , type = 2 },
            }
        },
        {
            name = "Bob",
            id = 20000,
            phone = {
                { number = "01234567890" , type = 3 },
            }
        }
    }
}

local binary_schema = parser.parse(schema)

local sproto_object = assert(sproto.newproto(binary_schema))

local type_object = assert(sproto.querytype(sproto_object, "AddressBook"))

local seri_stream = assert(sproto.encode(type_object, packet))

local pack_stream = assert(sproto.pack(seri_stream))

local unpack_stream = assert(sproto.unpack(pack_stream))

local origin_packet = sproto.decode(type_object, unpack_stream)

print(cclog(origin_packet))

-- RPC
