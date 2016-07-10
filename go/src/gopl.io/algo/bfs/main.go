/*
BFS(G, s)
	for each vertex u of G.V - {s}
		u.color = WHITE
		u.distance = INFINITE
		u.parent = nil

	s.color = GRAY
	s.distance = 0
	s.parent = nil

	Q = nil
	ENQUEUE(Q, s)
	while Q != nil
		u = DEQUEUE(Q)
		for each v of G.Adj[u]
			if v.color == WHITE
				v.color = GRAY
				v.distance = u.distance + 1
				v.parent = u
				ENQUEUE(Q, v)
		u.color = BLACK
*/

package main

import "fmt"

const (
	WHITE = iota
	GRAY
	BLACK
)

type Vertex struct {
	id       int
	color    int
	distance int
	parent   int
}

type Graph struct {
	adjancency_list map[int][]int
	vertex_list     map[int]*Vertex
}

type Queue struct {
	Q []int
}

func enqueue(Q *Queue, id int) {
	Q.Q = append(Q.Q, id)
}

func dequeue(Q *Queue) (id int) {
	id = Q.Q[0]
	Q.Q = Q.Q[1:]
	return
}

func isempty(Q *Queue) bool {
	if len(Q.Q) == 0 {
		return true
	} else {
		return false
	}
}

func BFS(graph *Graph, source_id int) {
	source := graph.vertex_list[source_id]
	source.color = GRAY
	source.distance = 0
	source.parent = -1

	Q := Queue{}

	enqueue(&Q, source_id)

	for !isempty(&Q) {
		u := dequeue(&Q)
		u_vertex := graph.vertex_list[u]

		for _, v := range graph.adjancency_list[u] {
			v_vertex := graph.vertex_list[v]
			if v_vertex.color == WHITE {
				v_vertex.color = GRAY
				v_vertex.distance = u_vertex.distance + 1
				v_vertex.parent = u
				enqueue(&Q, v)
			}
		}
		u_vertex.color = BLACK
	}
}

func add_vertex(graph *Graph, id int) {
	if graph.vertex_list == nil {
		graph.vertex_list = make(map[int]*Vertex)
	}
	graph.vertex_list[id] = &Vertex{
		id:       id,
		color:    WHITE,
		distance: -1,
		parent:   -1,
	}
}

func add_edge(graph *Graph, from_id int, to_id int) {
	if graph.adjancency_list == nil {
		graph.adjancency_list = make(map[int][]int)
	}
	graph.adjancency_list[from_id] = append(graph.adjancency_list[from_id], to_id)
}

func main() {
	graph := Graph{}

	add_edge(&graph, 1, 2)
	add_edge(&graph, 1, 3)
	add_edge(&graph, 1, 4)
	add_edge(&graph, 2, 5)
	add_edge(&graph, 2, 6)
	add_edge(&graph, 3, 7)
	add_edge(&graph, 4, 8)
	add_edge(&graph, 6, 9)
	add_edge(&graph, 9, 10)

	add_vertex(&graph, 1)
	add_vertex(&graph, 2)
	add_vertex(&graph, 3)
	add_vertex(&graph, 4)
	add_vertex(&graph, 5)
	add_vertex(&graph, 6)
	add_vertex(&graph, 7)
	add_vertex(&graph, 8)
	add_vertex(&graph, 9)
	add_vertex(&graph, 10)

	BFS(&graph, 1)

	for _, vertex := range graph.vertex_list {
		fmt.Printf("id(%d)\tcolor(%d)\td(%d)\tp(%d)\n",
			vertex.id, vertex.color, vertex.distance, vertex.parent)
	}
}
