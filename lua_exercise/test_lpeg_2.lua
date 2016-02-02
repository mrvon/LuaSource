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
local Cc = lpeg.Cc
local Cf = lpeg.Cf
local Cg = lpeg.Cg
local Cmt = lpeg.Cmt
local Cp = lpeg.Cp
local Cs = lpeg.Cs       -- substitution capture
local Ct = lpeg.Ct       -- a table with all captures from the pattern
local V = lpeg.V
local L = {} lpeg.locale(L)

-------------------------------------------------------------------------------

local __seri = serialize
function serialize(...)
    local args = table.pack(...)
    for i = 1, args.n do
        if args[i] then
            print(__seri(args[i]))
        end
    end
end

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

local space = L.space ^ 0
local name = C(L.alpha ^ 1) * space
local sep = S(",;") * space
local pair = Cg(name * "=" * space * name) * sep ^ -1
local list = Cf(Ct("") * pair^0, rawset)

serialize(list:match("a=b, c = hi; next = pi"))

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

serialize(split_into_table("Hello--world--2016", "--"))

print("------------------ Searching for a pattern")
function anywhere(p)
    return P {p + 1 * V(1)}
end

-- Another style
function anywhere(p)
    return P {
        "init_rule",
        init_rule = p + P(1) * V("init_rule")
    }
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

-- if match first word, ok
-- else skip first word, match next word. and so on.
function at_word_boundary(p)
    return P {
        -- index 1 is init rule
        [1] = C(P(p)) + L.alpha ^ 0 * (1 - L.alpha) ^ 1 * V(1)
    }
end

print(Match(at_word_boundary("hello"), "hello world!"))     -- hello
print(Match(at_word_boundary("world"), "hello world!"))     -- world
print(Match(at_word_boundary("world!"), "hello world!"))    -- world!
print(Match(at_word_boundary("worl"), "hello world!"))      -- worl
print(Match(at_word_boundary("orld"), "hello world!"))      -- nil
print(Match(at_word_boundary("hell"), "hello world!"))      -- hello
print(Match(at_word_boundary("ello"), "hello world!"))      -- nil


print("------------------ Balanced parentheses")

local balanced_parentheses = P {
    "(" * ((1 - S"()") + V(1)) ^ 0 * ")"
}

print(Match(anywhere(C(balanced_parentheses)), "can you (talk) with (me) ..."))
print(Match(anywhere(C(balanced_parentheses)), "(can you (talk) with (me)) ..."))

print("------------------ Global substitution")

function gsub(str, pattern, replace)
    pattern = P(pattern)
    pattern = Cs((pattern / replace + 1) ^ 0)
    return Match(pattern, str)
end

-- another style, easy to understand.
function gsub(str, pattern, replace)
    pattern = P(pattern)
    pattern = Cs(
        -- if pattern match, so replace it
        -- else match single character and replace by #
        (pattern / replace + P(1) / "#")
        ^ 0
    )
    return Match(pattern, str)
end

print("I love you more and more.")
print(gsub("I love you more and more.", "more", "less"))

print("------------------ Comma Separated Values (CSV)")

function csv(s)
    local field = '"' * Cs(((P(1) - '"') + P'""' / '"') ^ 0) * '"' + C((1 - S',\n"') ^ 0)
    local record = field * (',' * field) ^ 0 * (P'\n' + -1)
    return Match(Ct(record), s)
end

serialize(csv([[
1997,2015,Dennis,mrvon.github.com,"","string with <,> comma"
]]))

-- decode a two-byte UTF-8 sequence
local function f2(s)
    local beg_index = 1
    local end_index = 2
    local c1, c2 = string.byte(s, beg_index, end_index)
    return string.char(c1 * 64 + c2 - 12416)
end

-- decode a three-byte UTF-8 sequence
local function f3(s)
    local beg_index = 1
    local end_index = 3
    local c1, c2, c3 = string.byte(s, beg_index, end_index)
    return (c1 * 64 + c2) * 64 + c3 - 925824
end

-- decode a four-byte UTF-8 sequence
local function f4(s)
    local beg_index = 1
    local end_index = 4
    local c1, c2, c3, c4 = string.byte(s, beg_index, end_index)
    return ((c1 * 64 + c2) * 64 + c3) * 64 + c4 - 63447168
end

local cont = R("\128\191")  -- continuation byte

local utf8 = R("\0\127") / string.byte
           + R("\194\223") * cont / f2
           + R("\224\239") * cont / f3
           + R("\240\244") * cont / f4

local decode_pattern = Ct(utf8 ^ 0) * -1

serialize(Match(decode_pattern, "\97\98\194\129"))
serialize(Match(decode_pattern, "\194\129"))

do return end

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

print("------------------ Group and back captures")
serialize(Match(Ct(Cc"foo" * Cg(Cc"bar" * Cc"baz", "TAG") * Cc"qux"), ""))
serialize(
    Match(
    Ct(Cc"foo" * Cc"qux"), ""
    )
)

print("------------------ Of captures and values")
print((P(1) * C(C"b" * C"c") * P(1)):match"abcd")
serialize(Ct(P(1) * C(C"b" * C"c") * P(1)):match"abcd")
serialize(Ct(P(1) * C(C(P("b")) * C(P("c"))) * P(1)):match"abcd")

print(Cs(P(1) * C(C"b" * C"c") * P(1)):match("abcd"))

function the_func(bcd)
    assert(bcd == "bcd")
    return "B", "C", "D"
end

print((P(1) * (C"bcd" / the_func) * P(1)):match"abcde")
print(Cs(P(1) * (C"bcd" / the_func) * P(1)):match"abcde")

print("------------------ Anonymous groups")
print((P(1) * C"b" * C"c" * C"d" * P(1)):match"abcde")
print((P(1) * C(C"b" * C"c" * C"d") * P(1)):match"abcde")
print((P(1) * Cg(C"b" * C"c" * C"d") * P(1)):match"abcde")

serialize(Ct(P(1) * Cg(C"b" * C"c" * C"d") * P(1)):match"abcde")

-- TODO
print(Cs(P(1) * Cg(C"b" * C"c" * C"d") * P(1)):match"abcde")

print("------------------ Calc")
function calc(a, op, b)
    -- print(a, op, b)
    a = tonumber(a)
    b = tonumber(b)
    if op == "+" then
        return a + b
    else
        return a - b
    end
end

local digit = R"09"

calculate = Cf(
    C(digit) * Cg(C(S"+-") * C(digit)) ^ 0,
    calc
)

print(calculate:match"1")
print(calculate:match"1+2-3+4")

print("------------------ Name groups")
print((P(1) * Cg(C"bc", "FOOO") * C"d" * P(1) * Cb"FOOO" * Cb"FOOO"):match"abcde")

serialize((P(1) * Cg(C"b" * C"c" * C"d", "FOOO") * C"e" * Ct(Cb"FOOO")):match"abcde")

print("------------------ Equal Count Grammar")
local equal_count = P {
    "S", -- initial rule name
    S = "a" * V"B" + "b" * V"A" + "",
    A = "a" * V"S" + "b" * V"A" * V"A",
    B = "b" * V"S" + "a" * V"B" * V"B",
} * -1

print(C(equal_count):match"aaaabbbb")


print("------------------ Simple Name-value lists")
local name = C(L.alpha ^ 1)                         -- capture name is alpha serial
local sep = P","                                    -- separator
local pair = Cg(name * "=" * name) * sep ^ -1       -- Cg make make key-value pair as a single capture(this is importance)
local list = Cf(Ct("") * pair ^ 0, rawset)          -- Cf call rawset(rawset({}, key_1, value_1), key_2, value_2) ...
print(serialize(list:match("a=b,c=hi,next=pi")))
