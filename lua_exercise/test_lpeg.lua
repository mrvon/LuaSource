package.cpath = "luaclib/?.so"
package.path = "lualib/?.lua"

local lpeg = require "lpeg"

print(string.format("Welcome use Lpeg %s", lpeg.version()))

local Match = lpeg.match -- match a pattern against a string
local P = lpeg.P         -- match a string literally
local S = lpeg.S         -- match anything in a set
local R = lpeg.R         -- match anything in a range
local C = lpeg.C         -- captures a match
local Ct = lpeg.Ct       -- a table with all captures from the pattern

-------------------------------------------------------------------------------

-- local subject = "hello world"

-- local pattern = P("hello")  -- matches the string literally
-- local pattern = P(2)        -- if a pattern that matches exactly n characters
-- local pattern = P(-2)       -- only if the input string less than n characters left
-- local pattern = P(false)    -- boolean
-- local pattern = P(true)     -- boolean


-- local pattern = R("09")     -- character range
-- local pattern = R("az")     -- character range

-- local pattern = S("abc")    -- character set
-- local pattern = S("hk")     -- character set

-- local lower = R("az")
-- local upper = R("AZ")
-- local letter = lower + upper

-- local pattern = #P("hello")

-- local pattern = P("")
-- local pattern = -P("k")
-- local pattern = -P(1)

-- local pattern = R("az") - R("hz")

-- print(lpeg.match(pattern, subject))

-------------------------------------------------------------------------------
-- ^1 one or more
-- ^0 zero or more
-- ^-1 one or zero
-- The + operator means either one or the other pattern
-- The * operator means combining patterns in order 

-- Simple Matching
print(Match(P"a", "aaa"))
print(Match(P"a", "123"))

print(Match(R"09", "123"))
print(Match(S"123", "123"))

print(Match(P"a" ^ 1, "aaa"))
print(Match(P"a" * P"b" ^ 0, "abbc"))

local maybe_a = P"a" ^ -1
local match_ab = maybe_a * "b"
print(Match(match_ab, "ab"))
print(Match(match_ab, "b"))
print(Match(match_ab, "aaab"))

-- Basic Captures
local either_ab = (P"a" + P"b") ^ 1
print(either_ab:match "aaa")
print(either_ab:match "bbaa")

local digit = R"09"
local digits = digit ^ 1
local cdigits = C(digits)
print(cdigits:match "123")
print(string.sub("123", 1, Match(digits, "123")))

local int = S"+-" ^ -1 * digits
print(Match(C(int), "+23"))
print(string.sub("+23", 1, Match(int, "+23")))

print(Match(int / tonumber, "+123") + 1)

print(Match(C(P"a" ^ 1) * C(P"b" ^ 1), "aabbbb"))
print(string.match("aabbbb", "^(a+)(b+)"))

-- Building more complicated Patterns
function maybe(p)
    return p ^ -1
end
local digits = R"09" ^ 1
local mpm = maybe(S"+-")
local dot = S"."
local exp = S"eE"
local float = mpm * digits * maybe(dot * digits) * maybe(exp * mpm * digits)
local cfloat = C(float)

print(Match(cfloat, "2.3"))
print(Match(cfloat, "-2"))
print(Match(cfloat, "2e-02"))

local listf = C(float) * ("," * C(float)) ^ 0
print(Match(listf, "1.2,2.0,3.14,4"))

local float_list = Match(Ct(listf), "1.2,2.0,3.14,4")

function print_list(list)
    print("-------- list start --------")
    for i = 1, #list do
        print(list[i])
    end
    print("-------- list end ----------")
end

print_list(float_list)

local sp = P" " ^ 0
function space(patt)
    return sp * patt * sp
end
local floatc = space(float / tonumber)
local listc  = floatc * ("," * floatc) ^ 0
local float_list_2 = Match(Ct(listc), " 1, 2, 3")

print_list(float_list_2)

function list(patt)
    patt = space(patt)
    return patt * ("," * patt) ^ 0
end

local idenchar = R("AZ", "az") + P"_"
local iden = idenchar * (idenchar + R"09") ^ 0
print(list(C(iden)):match "hello, dolly, _x, s23")

local locale_list = {}
lpeg.locale(locale_list)

local iden_2 = (locale_list.alpha + P"_") * (locale_list.alnum + P"_") ^ 0
print(list(C(iden_2)):match "hello, dolly, _x, s23")

local rlistf = list(float / tonumber)
local csv = Ct( (Ct(rlistf) + "\n") ^ 1)
local csv_list = csv:match "1,2.3,3\n10,20, 30\n"

for i = 1, #csv_list do
    local list = csv_list[i]
    for j = 1, #list do
        io.write(list[j], "\t")
    end
    io.write("\n")
end

-- String Substituion
