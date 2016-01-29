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
local Cb = lpeg.Cb
local Cf = lpeg.Cf
local Cg = lpeg.Cg
local Cmt = lpeg.Cmt
local Cp = lpeg.Cp
local Cs = lpeg.Cs       -- substitution capture
local Ct = lpeg.Ct       -- a table with all captures from the pattern
local V = lpeg.V

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

print("------------------ Using a Pattern")
-- matches a word followed by end-of-string(-1)
local p = C(R"az" ^ 1 * -1)
print(p:match "hello")
print(p:match "1 hello")
print(p:match "hello ")

print("------------------ Name-value lists")
local L = {}
lpeg.locale(L)

local space = L.space ^ 0
local name = C(L.alpha ^ 1) * space
local sep = S(",;") * space
local pair = Cg(name * "=" * space * name) * sep ^ -1
local list = Cf(Ct("") * pair^0, rawset)

print(serialize(list:match("a=b, c = hi; next = pi")))

print("------------------ Splitting a string")
function split(str, sep)
    sep = P(sep)
    local element = C((P(1) - sep) ^ 0)
    local p = element * (sep * element) ^ 0
    return Match(p, str)
end

print(split("Hello--world--2016", "--"))

function split_into_table(str, sep)
    sep = P(sep)
    local element = C((P(1) - sep) ^ 0)
    local p = Ct(element * (sep * element) ^ 0) -- make a table capture
    return Match(p, str)
end

print(serialize(split_into_table("Hello--world--2016", "--")))

print("------------------ Searching for a pattern")
function anywhere(p)
    return P {p + 1 * V(1)}
end

print(Match(anywhere(C("world")), "Hello world"))

local I = Cp()
function anywhere_position(p)
    return P {I * p * I + 1 * V(1)}
end

-- find match position in the string
print(Match(anywhere_position("world"), "hello world!"))

local I = Cp()
function anywhere_position_2(p)
    return (1 - P(p)) ^ 0 * I * p * I
end

-- find match position in the string
print(Match(anywhere_position_2("world"), "hello world!"))

-- TODO grammars
function at_word_boundary(p)
    return P {
        [1] = p + L.alpha ^ 0 * (1 - L.alpha) ^ 1 * V(1)
    }
end

print("------------------ Balanced parentheses")

local balanced_parentheses = P {
    "(" * ((1 - S"()") + V(1)) ^ 0 * ")"
}

print(Match(anywhere(C(balanced_parentheses)), "can you (talk) with (me)"))

print("------------------ lua long string")
local equals = P"=" ^ 0
local open = "[" * Cg(equals, "init") * "[" * P"\n" ^ -1
local close = "]" * C(equals) * "]"
local closeeq = Cmt(close * Cb("init"), function(s, i, a, b)
    return a == b
end)
local long_string = open * C((P(1) - closeeq) ^ 0) * close / 1

print(Match(long_string, [==[
[[ Hello world ]]
]==]))
