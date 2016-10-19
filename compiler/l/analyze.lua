local Parser = require "parser"
local Analyzer = require "analyzer"

local syntax_tree = Analyzer.analyze()

Parser.trace(syntax_tree)
