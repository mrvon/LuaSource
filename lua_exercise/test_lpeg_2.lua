package.cpath = "luaclib/?.so"
package.path = "./?.lua;lualib/?.lua"

local lpeg = require "lpeg"
local seri = require "seri"


print(string.format("Welcome use Lpeg %s", lpeg.version()))

local Match = lpeg.match -- match a pattern against a string
local P = lpeg.P         -- match a string literally
local S = lpeg.S         -- match anything in a set
local R = lpeg.R         -- match anything in a range
local C = lpeg.C         -- captures a match
local Ct = lpeg.Ct       -- a table with all captures from the pattern
local Cs = lpeg.Cs       -- substitution capture
local Cg = lpeg.Cg
local Cf = lpeg.Cf

-------------------------------------------------------------------------------

local subject = "hello world"

local pattern = P("hello")  -- matches the string literally
local pattern = P(2)        -- if a pattern that matches exactly n characters
local pattern = P(-2)       -- only if the input string less than n characters left
local pattern = P(false)    -- boolean
local pattern = P(true)     -- boolean


local pattern = R("09")     -- character range
local pattern = R("az")     -- character range

local pattern = S("abc")    -- character set
local pattern = S("hk")     -- character set

local lower = R("az")
local upper = R("AZ")
local letter = lower + upper

local pattern = #P("hello")

local pattern = P("")
local pattern = -P("k")
local pattern = -P(1)

local pattern = R("az") - R("hz")

local pattern = C(P"hello") / "{{%1}}"

print(Match(pattern, subject))

-- matches a word followed by end-of-string(-1)
local p = C(R"az" ^ 1 * -1)
print(p:match "hello")
print(p:match "1 hello")
print(p:match "hello ")

local L = {}
lpeg.locale(L)

local space = L.space ^ 0
local name = C(L.alpha ^ 1) * space
local sep = S(",;") * space
local pair = Cg(name * "=" * space * name) * sep ^ -1
local list = Cf(Ct("") * pair^0, rawset)

print(serialize(list:match("a=b, c = hi; next = pi")))
