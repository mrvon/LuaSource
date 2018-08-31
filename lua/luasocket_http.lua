-- load the http module
http = require("socket.http")

local response_body = {}

r, c, h = http.request {
    method = "GET",
    url = "https://www.baidu.com",
    sink = ltn12.sink.table(response_body)
}

assert(r == 1)
assert(c == 200)

-- r is 1, c is 200, and h would return the following headers:
-- h = {
--   date = "Tue, 18 Sep 2001 20:42:21 GMT",
--   server = "Apache/1.3.12 (Unix)  (Red Hat/Linux)",
--   ["last-modified"] = "Wed, 05 Sep 2001 06:11:20 GMT",
--   ["content-length"] = 15652,
--   ["connection"] = "close",
--   ["content-Type"] = "text/html"
-- }

print(table.concat(response_body))
