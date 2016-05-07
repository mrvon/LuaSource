package.cpath = "luaclib/?.so"
package.path = "lualib/?.lua"

local crypt = require "crypt"
local parser = require "sprotoparser"
local sproto = require "sproto.core"

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

-- print(inspire(origin_packet))

-- RPC
