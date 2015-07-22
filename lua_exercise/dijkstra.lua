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
        local name_from, name_to, arc_lenght = string.match(line, "(%S+)%s+(%S+)%s+(%d+)")
        -- find corresponding nodes
        local from = name2node(graph, name_from)
        local to = name2node(graph, name_to)
        -- adds 'to' to the adjacent set of 'from'
        from.adj[to] = arc_lenght
    end
    return graph
end


local function extract_min(OpenSet, Dist)
    local min_len = nil
    local min_index = nil
    for i = 1, #OpenSet do
        local node = OpenSet[i]
        local len = Dist[node]
        if len then
            if min_len == nil or len < min_len then
                min_len = len
                min_index = i
            end
        end
    end
    local temp = OpenSet[min_index]
    table.remove(OpenSet, min_index)
    return temp
end

local function dijkstra(Graph, source, target)
    local CloseSet = {}
    local OpenSet  = {}
    local Dist     = {} -- Distance from source to node
    local Prev     = {} -- Previous node in optimal path

    local i = 1
    for _, node in pairs(Graph) do
        OpenSet[i] = node
        Dist[node] = math.huge
        i = i + 1
    end
    Dist[source] = 0

    while #OpenSet > 0 do
        local u = extract_min(OpenSet, Dist)
        table.insert(CloseSet, u)
        for v, d in pairs(u.adj) do
            if Dist[v] > Dist[u] + d then
                Dist[v] = Dist[u] + d
                Prev[v] = u
            end
        end
    end

    printpath(Prev, target, Dist)
end

local function breadth_first_find_path(Graph, source, target)
    local CloseSet = {}
    local OpenSet  = {}
    local Dist     = {}
    local Prev     = {}

    table.insert(OpenSet, source)

    local i = 1
    for _, node in pairs(Graph) do
        Dist[node] = math.huge
        i = i + 1
    end
    Dist[source] = 0

    while #OpenSet > 0 do
        local u = OpenSet[1]
        table.remove(OpenSet, 1)

        for v, d in pairs(u.adj) do
            if Dist[v] > Dist[u] + d then
                Dist[v] = Dist[u] + d
                Prev[v] = u
            end

            if not CloseSet[v] then
                CloseSet[v] = true
                table.insert(OpenSet, v)
            end
        end
    end

    printpath(Prev, target, Dist)
end

function printpath(Prev, target, Dist)
    print("path length: " .. Dist[target])

    while Prev[target] do
        io.write(target.name .. " ")
        target = Prev[target]
    end

    print(target.name)
end

Graph = readgraph()
source = name2node(Graph, "a")
target = name2node(Graph, "b")

dijkstra(Graph, source, target)
breadth_first_find_path(Graph, source, target)
