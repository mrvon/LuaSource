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

print(Match(P"a", "aaa"))
print(Match(P"a", "123"))

print(Match(R"09", "123"))
print(Match(S"123", "123"))

print(Match(P"a" ^ 1, "aaa"))
print(Match(P"a" * P"b" ^ 0, "abbc"))

local maybe_a = P"a" ^ -1
local maybe_ab = maybe_a * "b"
print(Match(maybe_ab, "ab"))
print(Match(maybe_ab, "b"))
print(Match(maybe_ab, "aaab"))

local either_ab = (P"a" + P"b") ^ 1
print(either_ab:match "aaa")
print(either_ab:match "bbaa")
