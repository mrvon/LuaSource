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


local function extract_min(Q, D)
    local min_len = nil
    local min_index = nil
    for i = 1, #Q do
        local node = Q[i]
        local len = D[node]
        if len then
            if min_len == nil or len < min_len then
                min_len = len
                min_index = i
            end
        end
    end
    local temp = Q[min_index]
    table.remove(Q, min_index)
    return temp
end

local function dijkstra(g, s, w)
    local D = {}
    local S = {}
    local Q = {}
    local P = {}

    local i = 1
    for _, node in pairs(g) do
        Q[i] = node
        D[node] = math.huge
        i = i + 1
    end
    D[s] = 0

    while #Q > 0 do
        local u = extract_min(Q, D)
        table.insert(S, u)
        for v, d in pairs(u.adj) do
            if D[v] > D[u] + d then
                D[v] = D[u] + d
                P[v] = u
            end
        end
    end

    printpath(P, w, D)
end

local function breadth_first_find_path(g, s, w)
    local visited = {}
    local Q = {}
    local D = {}
    local P = {}
    table.insert(Q, s)

    local i = 1
    for _, node in pairs(g) do
        D[node] = math.huge
        i = i + 1
    end
    D[s] = 0

    while #Q > 0 do
        local u = Q[1]
        table.remove(Q, 1)

        for v, d in pairs(u.adj) do
            if D[v] > D[u] + d then
                D[v] = D[u] + d
                P[v] = u
            end

            if not visited[v] then
                visited[v] = true
                table.insert(Q, v)
            end
        end
    end

    printpath(P, w, D)
end

function printpath(P, w, D)
    print("path length: " .. D[w])
    while P[w] do
        io.write(w.name .. " ")
        w = P[w]
    end
    print(w.name)
end

g = readgraph()
s = name2node(g, "a")
w = name2node(g, "b")

dijkstra(g, s, w)
breadth_first_find_path(g, s, w)
