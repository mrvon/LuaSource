local function name2node(graph, name)
    local node = graph[name]
    if not node then
        -- node does not exist; create a new one
        node = {name = name, adj = {} }
        graph[name] = node
    end
    return node
end

local function readgraph()
    local graph = {}
    for line in io.lines() do
        -- split line in two names
        local name_from, name_to, arc_length = string.match(line, "(%S+)%s+(%S+)%s+(%d+)")
        -- find corresponding nodes
        local from = name2node(graph, name_from)
        local to = name2node(graph, name_to)
        -- adds 'to' to the adjacent set of 'from'
        from.adj[to] = arc_length
    end
    return graph
end

-- deep first search
local function depth_first_find_path(curr, to, path, visited)
    path = path or {}
    visited = visited or {}
    if visited[curr] then  -- node already visited
        return nil         -- no path here
    end
    visited[curr] = true   -- make node as visited
    path[#path + 1] = curr -- add it to path
    if curr == to then     -- final node?
        return path
    end
    -- try all adjacent nodes
    for node in pairs(curr.adj) do
        local p = depth_first_find_path(node, to, path, visited)
        if p then
            return p
        end
    end
    path[#path] = nil       -- remove node from path
end

local function printpath(path)
    if not path then
        io.write("path is empty\n")
        return
    end

    for i = 1, #path do
        local node = path[i]
        local pre_node = path[i - 1]
        if pre_node then
            io.write(string.format(" (%d) ", pre_node.adj[node]))
        end
        io.write(node.name)
    end
    io.write("\n")
end

g = readgraph()
a = name2node(g, "a")
b = name2node(g, "b")
p = depth_first_find_path(a, b)
printpath(p)
