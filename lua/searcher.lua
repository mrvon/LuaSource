local searchers = {}

-- just as package.searcher[2], lua library searchers
table.insert(searchers, function(mod_name)
    local extra, msg = package.searchpath(mod_name, package.path)
    if extra then
        return function(...)
            local f = loadfile(extra)
            return f(...)
        end, extra
    else
        return msg
    end
end)

local function findloader(mod_name)
    local msg = {}
    for _, searcher in pairs(searchers) do
        local loader, extra = searcher(mod_name)
        if type(loader) == "function" then
            return loader, extra
        elseif type(loader) == "string" then
            table.insert(msg, loader)
        end
    end
	error(string.format("module '%s' not found:%s", name, table.concat(msg)))
end

local loader, extra = findloader("list")
loader(extra, "hello world")
