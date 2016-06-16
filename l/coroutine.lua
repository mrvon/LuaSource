print("-------------- Test 1 --------------")
local co = coroutine.create(function() print("Hello world") end)

print(type(co))
print(coroutine.status(co))
coroutine.resume(co)
print(coroutine.status(co))

local co = coroutine.create(function()
    for i = 1, 10 do
        print("co", i)
        coroutine.yield(co)
    end
end)

coroutine.resume(co)
print(coroutine.status(co))
coroutine.resume(co)
print(coroutine.status(co))
coroutine.resume(co)
coroutine.resume(co)
coroutine.resume(co)
coroutine.resume(co)
coroutine.resume(co)
coroutine.resume(co)
coroutine.resume(co)
coroutine.resume(co)
coroutine.resume(co)
print(coroutine.resume(co))

print("-------------- Test 2 --------------")
local co = coroutine.create(function(a, b, c) 
    print("co", a, b, c + 2)
end)
local ok, msg = coroutine.resume(co, 1, 2, 3)
print(ok, msg)

print("-------------- Test 3 --------------")
local co = coroutine.create(function(a, b)
    coroutine.yield(a + b, a - b)
end)
print(coroutine.resume(co, 20, 10))

print("-------------- Test 4 --------------")
local co = coroutine.create(function(x)
    print("co1", x)
    print("co2", coroutine.yield())
end)
coroutine.resume(co, "hi")
coroutine.resume(co, 4, 5)

print("-------------- Test 5 --------------")
co = coroutine.create(function()
    return 6, 7
end)
print(coroutine.resume(co))

print("-------------- Test 6 --------------")
-- function receive()
--     local status, value = coroutine.resume(producer)
--     return value
-- end

-- function send(x)
--     coroutine.yield(x)
-- end

-- producer = coroutine.create(function()
--     while true do
--         local x = io.read()
--         send(x)
--     end
-- end)

-- print(receive())
-- print(receive())
-- print(receive())

print("-------------- Test 7 --------------")
-- function receive()
--     return coroutine.yield()
-- end

-- function send(x)
--     local status, value = coroutine.resume(consumer, x)
--     return value
-- end

-- consumer = coroutine.create(function()
--     while true do
--         print(receive())
--     end
-- end)

-- send(nil)
-- send("Hello world")
-- send("Superman")

print("-------------- Test 8 --------------")
-- function receive(prod)
--     local status, value = coroutine.resume(prod)
--     return value
-- end

-- function send(x)
--     coroutine.yield(x)
-- end

-- function producer()
--     return coroutine.create(function()
--         while true do
--             local x = io.read() -- produce new value
--             send(x)
--         end
--     end)
-- end

-- function filter(prod)
--     return coroutine.create(function()
--         for line = 1, math.huge do
--             local x = receive(prod) -- get new value
--             x = string.format("%5d %s", line, x)
--             send(x)
--         end
--     end)
-- end

-- function consumer(prod)
--     while true do
--         local x = receive(prod) -- get new value
--         io.write(x, "\n") -- consume new value
--     end
-- end

-- p = producer()
-- f = filter(p)
-- consumer(f)

print("-------------- Test 8 --------------")
-- function permgen(a, n)
--     n = n or #a     -- default for 'n' is size of 'a'
--     if n <= 1 then
--         printResult(a)
--     else
--         for i = 1, n do
--             -- put i-th element as the last one
--             a[n], a[i] = a[i], a[n]
--             -- generate all permutations of the other elements
--             permgen(a, n - 1)
--             -- restore i-th element
--             a[n], a[i] = a[i], a[n]
--         end
--     end
-- end

-- function printResult(a)
--     for i = 1, #a do
--         io.write(a[i], " ")
--     end
--     io.write("\n")
-- end

-- permgen({1, 2, 3, 4})


print("-------------- Test 9 --------------")
-- function permgen(a, n)
--     n = n or #a     -- default for 'n' is size of 'a'
--     if n <= 1 then
--         coroutine.yield(a)
--     else
--         for i = 1, n do
--             -- put i-th element as the last one
--             a[n], a[i] = a[i], a[n]
--             -- generate all permutations of the other elements
--             permgen(a, n - 1)
--             -- restore i-th element
--             a[n], a[i] = a[i], a[n]
--         end
--     end
-- end

-- function permutations(a)
--     local co = coroutine.create(function()
--         permgen(a)
--     end)
--     return function()   -- iterator
--         local code, res = coroutine.resume(co)
--         return res
--     end
-- end

-- function permutations_wrap(a)
--     return coroutine.wrap(function() 
--         permgen(a)
--     end)
-- end

-- function print_array(a)
--     for i = 1, #a do
--         io.write(a[i], " ")
--     end
--     io.write("\n")
-- end

-- for p in permutations_wrap({"a", "b", "c"}) do
--     print_array(p)
-- end

print("-------------- Test 10 --------------")
-- local socket = require "socket"

-- function download(host, file)
--     local c = assert(socket.connect(host, 80))
--     local count = 0
--     c:send("GET " .. file .. " HTTP/1.0\r\n\r\n")
--     while true do
--         local s, status = receive(c)
--         count = count + #s
--         if status == "closed" then
--             break
--         end
--     end
--     c:close()
--     print(file, count)
-- end

-- function receive(connection)
--     connection:settimeout(0)    -- do not black
--     local s, status, partial = connection:receive(2^10)
--     if status == "timeout" then
--         coroutine.yield(connection)
--     end
--     return s or partial, status
-- end

-- thread = {}     -- list of all live threads

-- function get(host, file)
--     -- create coroutine
--     local co = coroutine.create(function()
--         download(host, file)
--     end)
--     -- insert it in the list
--     table.insert(threads, co)
-- end

-- function dispatch()
--     local i = 1
--     while true do
--         if threads[i] == nil then   -- no more threads
--             if threads[1] == nil then -- list is empty?
--                 break
--             end
--             i = 1   -- restart the loop
--         end

--         local status, res = coroutine.resume(threads[i])
--         if not res then -- thread finished its task?
--             table.remove(threads, i)
--         else
--             i = i + 1 -- go to next thread
--         end
--     end
-- end

-- function select_dispatch()
--     local i = 1
--     local timedout = {}
--     while true do
--         if threads[i] == nil then
--             if threads[1] == nil then -- no more threads
--                 break
--             end
--             i = 1    -- restart the loop
--             timedout = {}
--         end

--         local status, res = coroutine.resume(threads[i])
--         if not res then
--             table.remove(threads, i)
--         else -- time out
--             i = i + 1
--             timedout[#timedout + 1] = res
--             if #timedout == #threads then -- all threads blocked?
--                 socket.select(timedout)
--             end
--         end
--     end
-- end

-- host = "www.w3.org"
-- get(host, "/TR/html401/html40.txt")

-- dispatch()

print("Solution Exercise 9.1")
-- function combingen(a, c, n, m)
--     if n == 1 or m == 0 or n <= m then
--         -- print(string.format("N%d M%d", n, m))
--         local c2 = {}
--         for i = 1, #c do
--             table.insert(c2, c[i])
--         end
--         if m > 0 then
--             for i = n, 1, -1 do
--                 table.insert(c2, a[i])
--             end
--         end
--         coroutine.yield(c2)
--     else
--         -- print(string.format("N%d M%d", n, m))
--         combingen(a, c, n - 1, m)
--         table.insert(c, a[n])
--         combingen(a, c, n - 1, m - 1)
--         table.remove(c, #c)
--     end
-- end

-- function combinations(a, m)
--     local co = coroutine.create(function()
--         local n = #a
--         local c = {}
--         combingen(a, c, n, m)
--     end)
--     return function() -- iterator
--         local code, res = coroutine.resume(co)
--         return res
--     end
-- end

-- function printcombin(c)
--     for i = #c, 1, -1 do
--         io.write(c[i] .. " ")
--     end
--     io.write("\n")
-- end

-- for c in combinations({"a", "b", "c", "d"}, 2) do
--     printcombin(c)
-- end

-- print("Solution Exercise 9.2")
print("Solution Exercise 9.3")

local thread_map = {}
function create_thread(tag)
    local max = 3
    local i = 0
    local ot = os.time()
    local co = coroutine.create(function()
        while true do
            local nt = os.time()
            local dt = os.difftime(nt, ot)
            if math.abs(dt) > 1 then
                i = i + 1
                if i > max then
                    break
                end

                print(string.format("%s - %d", tag, i))
                ot = nt

                transfer(other_thread_tag(tag))
            end
        end
    end)
    thread_map[tag] = co
end

function create_all_thread()
    create_thread("Hello world")
    create_thread("Log")
    local dispatch = coroutine.create(dispatch_thread)
    coroutine.resume(dispatch, "Hello world")
end

function other_thread_tag(tag)
    for thread_tag in pairs(thread_map) do
        if thread_tag ~= tag then
            return thread_tag
        end
    end
end

function transfer(tag)
    coroutine.yield(tag)
end

function dispatch_thread(tag)
    while true do
        local co = thread_map[tag]
        if co == nil then
            break
        end
        local status, value = coroutine.resume(co)
        if not status then
            break
        end
        tag = value
    end
end

create_all_thread()
