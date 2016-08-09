/*
The algorithm works on both directed and undirected graphs.

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

import (
	"fmt"
)

const (
	WHITE = iota
	GRAY
	BLACK
)

type Vertex struct {
	id       int
	color    int
	distance int
	parent   *Vertex
}

type Graph struct {
	adjancency_list map[int][]int
	vertex_list     map[int]*Vertex
}

func (graph *Graph) add_vertex(id int) {
	if graph.vertex_list == nil {
		graph.vertex_list = make(map[int]*Vertex)
	}
	graph.vertex_list[id] = &Vertex{
		id:       id,
		color:    WHITE,
		distance: -1,
		parent:   nil,
	}
}

func (graph *Graph) add_edge(from_id int, to_id int) {
	if graph.adjancency_list == nil {
		graph.adjancency_list = make(map[int][]int)
	}
	graph.adjancency_list[from_id] = append(graph.adjancency_list[from_id], to_id)
}

type Queue struct {
	Q []int
}

func (Q *Queue) enqueue(id int) {
	Q.Q = append(Q.Q, id)
}

func (Q *Queue) dequeue() (id int) {
	id = Q.Q[0]
	Q.Q = Q.Q[1:]
	return
}

func (Q *Queue) isempty() bool {
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
	source.parent = nil

	Q := Queue{}

	Q.enqueue(source_id)

	for !Q.isempty() {
		u := Q.dequeue()
		u_vertex := graph.vertex_list[u]

		for _, v := range graph.adjancency_list[u] {
			v_vertex := graph.vertex_list[v]
			if v_vertex.color == WHITE {
				v_vertex.color = GRAY
				v_vertex.distance = u_vertex.distance + 1
				v_vertex.parent = u_vertex
				Q.enqueue(v)
			}
		}
		u_vertex.color = BLACK
	}
}

func print_path(graph *Graph, from_id int, to_id int) {
	from := graph.vertex_list[from_id]
	if from == nil {
		return
	}

	to := graph.vertex_list[to_id]
	if to == nil {
		return
	}

	fmt.Printf("Path from vertex(%d) to vertex(%d)\n", from_id, to_id)
	fmt.Printf("----------------------------------\n")
	aux_print_path(graph, from_id, to_id)
	fmt.Printf("----------------------------------\n")
}

func aux_print_path(graph *Graph, from_id int, to_id int) {
	to := graph.vertex_list[to_id]

	if from_id == to_id {
		fmt.Printf("vertex id(%d)\n", to_id)
	} else if to.parent == nil {
		fmt.Printf("No path from %d to %d\n", from_id, to_id)
	} else {
		aux_print_path(graph, from_id, to.parent.id)
		fmt.Printf("vertex id(%d)\n", to_id)
	}
}

func main() {
	graph := &Graph{}

	graph.add_edge(1, 2)
	graph.add_edge(1, 3)
	graph.add_edge(1, 4)
	graph.add_edge(2, 5)
	graph.add_edge(2, 6)
	graph.add_edge(3, 7)
	graph.add_edge(4, 8)
	graph.add_edge(6, 9)
	graph.add_edge(9, 10)

	graph.add_vertex(1)
	graph.add_vertex(2)
	graph.add_vertex(3)
	graph.add_vertex(4)
	graph.add_vertex(5)
	graph.add_vertex(6)
	graph.add_vertex(7)
	graph.add_vertex(8)
	graph.add_vertex(9)
	graph.add_vertex(10)

	BFS(graph, 1)

	for _, vertex := range graph.vertex_list {
		fmt.Printf("vertex id(%d)\tcolor(%d)\tdistance(%d)\t",
			vertex.id,
			vertex.color,
			vertex.distance)

		if vertex.parent == nil {
			fmt.Printf("parent(nil)\n")
		} else {
			fmt.Printf("parent(%d)\n", vertex.parent.id)
		}
	}

	print_path(graph, 1, 10)
	print_path(graph, 2, 9)
	print_path(graph, 2, 7)
}
