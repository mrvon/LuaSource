local Parser = require "parser"
local Inspect = require "inspect"

local syntax_tree = Parser.parse()
Parser.trace(syntax_tree)

-- print(Inspect.inspect(syntax_tree))
