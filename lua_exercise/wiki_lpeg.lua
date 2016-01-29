package.cpath = "luaclib/?.so"
package.path = "lualib/?.lua"

local lpeg = require "lpeg"

print(string.format("Welcome use Lpeg %s", lpeg.version()))

local Match = lpeg.match -- match a pattern against a string
local P = lpeg.P         -- match a string literally
local S = lpeg.S         -- match anything in a set
local R = lpeg.R         -- match anything in a range
local C = lpeg.C         -- captures a match
local Cb = lpeg.Cb
local Cf = lpeg.Cf
local Cg = lpeg.Cg
local Cmt = lpeg.Cmt
local Cp = lpeg.Cp
local Cs = lpeg.Cs       -- substitution capture
local Ct = lpeg.Ct       -- a table with all captures from the pattern
local V = lpeg.V

-------------------------------------------------------------------------------

local wiki_text = [[
## A title

here _we go_ and `a:bonzo()`:

    one line
    two line
    three line
       
and `more_or_less_something`

[A reference](http://bonzo.dog)

> quoted
> lines
 
]]

function subst(openp, repl, endp)
    opep = P(openp) -- make sure it's a pattern
    endp = endp and P(endp) or openp

    --pattern is 'bracket followed by any number of non-bracket followed by bracket'
    local contents = C((P(1) - endp) ^ 1)
    local patt = openp * contents * endp
    if repl then
        patt = patt / repl
    end
    return patt
end

function empty(p)
    return C(p) / ''
end

local lf = P"\n"
local rest_of_line = C((1 - lf) ^ 1)
local rest_of_line_nl = C((1 - lf) ^ 0 * lf)

-- indented code block
local indent = P"\t" + P"    "
local indented = empty(indent) * rest_of_line_nl
-- which we'll assume are Lua code
local block = Cs(indented ^ 1) / '    [[[!Lua\n%1]]]\n'

-- use > to get simple quoted block
local quoted_line = empty("> ") * rest_of_line_nl
local quote = Cs(quoted_line ^ 1) / "[[[\n%1]]]\n"

local code = subst('`', '{{%1}}')
local italic = subst('_', "''%1''")
local bold = subst('**', "'''%1'''")
local rest_of_line = C((1 - lf) ^ 1)
local title1 = P'##' * rest_of_line / '=== %1 ==='
local title2 = P'###' * rest_of_line / '== %1 =='

local url = (subst('[', nil, ']') * subst('(', nil, ')')) / '[%2 %1]'

local item = block + title1 + title2 + code + italic + bold + quote + url + 1
local text = Cs(item ^ 1)

if arg[1] then
    local f = io.open(arg[1])
    wiki_text = f:read '*a'
    f:close()
end

print(text:match(wiki_text))

