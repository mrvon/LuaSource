local socket = require "socket"

function download(host, file)
    local c = assert(socket.connect(host, 80))
    local count = 0

    c:send("GET " .. file .. " HTTP/1.0\r\n\r\n")

    while true do
        local s, status = receive(c)
        count = count + #s
        if status == "closed" then
            break
        end
    end

    c:close()
    print(file, count)
end

function receive(c)
    c:settimeout(0)
    local s, status, partial = c:receive(2^10)
    if status == "timeout" then
        coroutine.yield(c)
    end
    return s or partial, status
end

local threads = {}

function get(host, file)
    -- create coroutine
    local co = coroutine.create(function()
        download(host, file)
    end)
    -- insert it in the list
    table.insert(threads, co)
end

function busywait_dispatch()
    local i = 1
    while true do
        if threads[i] == nil then                        -- no more threads?
            if threads[1] == nil then                    -- list is empty?
                break
            end
            i = 1                                        -- restart the loop
        end

        local status, res = coroutine.resume(threads[i])
        if not res then                                  -- thread finish its task?
            table.remove(threads, i)
        else
            i = i + 1                                    -- go to next thread
        end
    end
end

function select_dispatch()
    local i = 1
    local timed_out = {}
    while true do
        if threads[i] == nil then                        -- no more threads?
            if threads[1] == nil then                    -- list is empty?
                break
            end
            i = 1                                        -- restart the loop
            timed_out = {}
        end

        local status, res = coroutine.resume(threads[i])
        if not res then                                  -- thread finish its task?
            table.remove(threads, i)
        else
            i = i + 1                                    -- go to next thread
            timed_out[#timed_out + 1] = res
            if #timed_out == #threads then
                socket.select(timed_out)
            end
        end
    end
end

local host = "www.baidu.com"
get(host, "/")
get(host, "/")
get(host, "/")
get(host, "/")
get(host, "/")

select_dispatch()
