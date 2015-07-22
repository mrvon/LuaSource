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
        CloseSet[u] = true
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

--------------------------------------------------------------------------------

local function extract_min_fscore(OpenSet, Fscore)
    local min_fscore = nil
    local min_node = nil
    for node, _ in pairs(OpenSet) do
        local fscore = Fscore[node]
        if fscore then
            if min_fscore == nil or fscore < min_fscore then
                min_fscore = fscore
                min_node = node
            end
        end
    end

    OpenSet[min_node] = nil

    return min_node
end

local function heuristic(source, target)
    return 1
end

local function is_empty(OpenSet)
    for _, _ in pairs(OpenSet) do
        return false
    end
    return true
end

-- f(x) = g(x) + h(x)
local function astar(Graph, source, target)
    local CloseSet = {}
    local OpenSet = {}
    local Gscore = {}
    local Fscore = {}
    local Prev = {}

    OpenSet[source] = true

    local i = 1
    for _, node in pairs(Graph) do
        Gscore[node] = math.huge
        Fscore[node] = math.huge
        i = i + 1
    end

    Gscore[source] = 0
    Fscore[source] = Gscore[source] + heuristic(source, target)

    while not is_empty(OpenSet) do
        local u = extract_min_fscore(OpenSet, Fscore)
        if u == target then
            printpath(Prev, target, Gscore)
            return
        end

        CloseSet[u] = true

        for v, d in pairs(u.adj) do
            if not CloseSet[v] then
                local tentative_g_score = Gscore[u] + d

                if not OpenSet[v] or tentative_g_score < Gscore[v] then
                    Gscore[v] = tentative_g_score
                    Fscore[v] = Gscore[v] + heuristic(v, target)
                    Prev[v] = u

                    if not OpenSet[v] then
                        OpenSet[v] = true
                    end
                end
            end
        end
    end
end
--------------------------------------------------------------------------------


Graph = readgraph()
source = name2node(Graph, "a")
target = name2node(Graph, "b")

dijkstra(Graph, source, target)
breadth_first_find_path(Graph, source, target)
astar(Graph, source, target)
