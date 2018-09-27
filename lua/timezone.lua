--[[
0       -> 1970-01-01 00:00:00 (UTC+0) 调和世界时
0       -> 1970-01-01 08:00:00 (UTC+8) 北京时间
-28800  -> 1970-01-01 00:00:00 (UTC+8) 北京时间

在程序里面
* 时间戳统一使用UTC+0时区简化问题
* 日期统一使用当地时区简化问题
]]

local inspect = require "inspect".inspect
-- 本机时区UTC+8
local TIME_ZONE = 8
local HOUR_SECONDS = 3600

-- UTC timestamp -> UTC date
local function utc_date(ts)
    -- 在os.date() 的 format 字符串如果是以!开头，表示返回结果使用的是UTC时间，
    -- 否则使用当地时区时间。
    return os.date("!*t", ts)
end

print("0 -> UTC date:", inspect(utc_date(0)))

local function local_time(d)
    return os.time(d)
end

local function local_date(t)
    -- os.time() 使用的也是当地时区时间，所以需要补偿时区偏移
    return utc_date((t or os.time()) + TIME_ZONE * HOUR_SECONDS)
end

print("NOW: Local time:", local_time())
print("NOW: Local date:", inspect(local_date()))

-- UNIXTIME=0 转换为日期(UTC+8)
-- print(inspect(os.date("*t", 0)))
-- print(inspect(os.date("%c", 0)))

-- UNIXTIME=0 转换为日期(UTC+0)
-- print(inspect(os.date("!*t", 0)))
-- print(inspect(os.date("!%c", 0)))
