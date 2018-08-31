local env = {}
local chuckname = "fuck_chunk"
local mode = "t" -- text mode

local f = assert(load("fuck = 2", chuckname, "t", env))
f()

print("-------------------------------------")
for k, v in pairs(env) do
    print(k, v)
end
print("-------------------------------------")

local f = assert(load("fuck = 2", chuckname, "t", _ENV))
-- same as following line
-- local f = assert(load("fuck = 2", chuckname, "t"))

f()
print(fuck)
