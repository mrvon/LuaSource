-- 0       -> 1970-01-01 00:00:00 (UTC+0) 调和世界时
-- 0       -> 1970-01-01 08:00:00 (UTC+8) 北京时间
-- -28800  -> 1970-01-01 00:00:00 (UTC+8) 北京时间

local inspect = require "inspect".inspect

local timestamp = os.time({
    year = 1970,
    month = 1,
    day = 1,
    hour = 0,
    minute = 0,
    second = 0,
})
print(timestamp)

-- UNIXTIME=0 转换为日期(UTC+8)
print(inspect(os.date("*t", 0)))

-- UNIXTIME=0 转换为日期(UTC+0)
print(inspect(os.date("!*t", 0)))

-- 在程序里面统一使用UTC+0 简化问题
-- timestamp -> date
local function standard_time(ts)
    -- 在os.date() 的 format 字符串如果是以!开头，表示返回结果使用的是UTC时间，
    -- 否则使用当地时区时间。
    return os.date("!*t", ts)
end

print(inspect(standard_time(0)))

-- 本机时区UTC+8
local time_zone = 8

-- date -> timestamp
local function standard_date(d)
    -- os.time() 使用的也是当地时区时间，所以需要补偿时区偏移
    return os.time(d) + time_zone * 3600
end

print(standard_date(standard_time(0)))
