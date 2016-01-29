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
local Cs = lpeg.Cs       -- substitution capture

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
local ciden = C(iden)
print(list(ciden):match "hello, dolly, _x, s23")

local locale_list = {}
lpeg.locale(locale_list)

local iden_2 = (locale_list.alpha + P"_") * (locale_list.alnum + P"_") ^ 0
local ciden_2 = C(iden_2)
print(list(ciden_2):match "hello, dolly, _x, s23")


-- rlistf is a litter tricky
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
local Q = P'"'
local str_patt = Q * (P(1) - Q) ^ 0 * Q

print(Match(C(str_patt), [[
"Hello world" is a string.
]]))

local str_patt_2 = Q * C((P(1) - Q) ^ 0) * Q
print(Match(str_patt_2, [[
"Hello world" is a string.
]]))

function extract_quote(openp, endp)
    openp = P(openp)
    endp = endp and P(endp) or openp
    
    local upto_endp = (P(1) - endp) ^ 1
    return openp * C(upto_endp) * endp
end

print(extract_quote("(", ")"):match "(and more)")
print(extract_quote("[[", "]]"):match "[[long string]]")

function subst(openp, repl, endp)
    openp = P(openp)
    endp = endp and P(endp) or openp
    local upto_endp = (P(1) - endp) ^ 1
    return openp * C(upto_endp) / repl * endp
end

print(subst('`', '{{%1}}'):match '`code`')
print(subst('_', "''%1''"):match '_italics_')
print(string.gsub('_italics_', '^_([^_]+)_', "''%1''"))

function gsub(s, patt, repl)
    patt = P(patt)
    local p = Cs(((patt / repl) + P(1)) ^ 0)
    return p:match(s)
end

print(gsub("hello dog, dog!", "dog", "cat"))

local p = C(((P"dog" / "cat") + 1) ^ 0)
local c1, c2, c3 = p:match "hello dog, dog!"
print(c1)
print(c2)
print(c3)

local lf = P"\n"
local rest_of_line_nl = C((P(1) - lf) ^ 0 * lf)  -- capture chars upto \n
local quoted_line = P"> " * rest_of_line_nl      -- block quote lines start with '>'

-- collect the quoted lines and put inside [[[..]]]
local quote = Cs(quoted_line ^ 1) / "[[[\n%1]]]\n"
print(quote:match "> hello\n> dolly\n")

function empty(p)
    return C(p) / ''
end
local quoted_line = empty('> ') * rest_of_line_nl

-- collect the quoted lines and put inside [[[..]]]
local quote = Cs(quoted_line ^ 1) / "[[[\n%1]]]\n"
print(quote:match "> hello\n> dolly\n")
