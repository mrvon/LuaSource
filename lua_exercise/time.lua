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
