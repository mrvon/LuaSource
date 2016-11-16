local Parser = require "jsonparser"
local Inspect = require "inspect"

local object = Parser.parse()

print(Inspect.inspect(object))
