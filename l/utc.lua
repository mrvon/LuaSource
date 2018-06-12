-- UTC
local utc = os.time(os.date("!*t"))

-- LocalTimeZone
local loc = os.time(os.date("*t"))
print(string.format("UTC+%d", (loc - utc) / 3600))

-- LocalTimeZone
local cur = os.time()
assert(cur == loc)

-- EPOCH
local timestamp = os.time({
    year = 1970,
    month = 1,
    day = 1,
    hour = 0,
    minute = 0,
    second = 0,
})
print("EPOCH", timestamp)

local timestamp = os.time({
    year = 1970,
    month = 1,
    day = 1,
    hour = 8,
    minute = 0,
    second = 0,
})
print("EPOCH", timestamp)
