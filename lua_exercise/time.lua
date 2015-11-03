local time = "2015_10_31_23_40_26"

local time_table = {}
for w in string.gmatch(time, "[0-9]+") do
    table.insert(time_table, w)
end

print(os.time{
    year = time_table[1],
    month = time_table[2],
    day = time_table[3],
    hour = time_table[4],
    min = time_table[5],
    sec = time_table[6],
})

local date = os.date("*t", 1)
print(
    date.year,
    date.month,
    date.day,
    date.hour,
    date.min,
    date.sec
)

function day_diff(time_x, time_y)
    if time_x < time_y then
        time_x, time_y = time_y, time_x
    end

    local date_x = os.date("*t", time_x)
    local date_y = os.date("*t", time_y)

    date_x.hour = 0
    date_x.min = 0
    date_x.sec = 0
    date_y.hour = 0
    date_y.min = 0
    date_y.sec = 0

    local diff_time = os.time(date_x) - os.time(date_y)
    return diff_time / (3600 * 24)
end
