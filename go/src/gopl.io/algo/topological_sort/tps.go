/*
The algorithm works on directed acyclic graphs.

TOPOLOGICAL_SORT(G)
	call DFS(G) to compute finishing times v.f for each vertex v
	as each vertex is finished, insert it onto the front of a linked list
	return the linked list of vertices
*/

package main

import (
	"fmt"
	"sort"
)

const (
	WHITE = iota
	GRAY
	BLACK
)

type Vertex struct {
	id            int
	color         int
	time_discover int
	time_finish   int
	parent        *Vertex
}

type VertexList []*Vertex

func (v VertexList) Len() int           { return len(v) }
func (v VertexList) Less(i, j int) bool { return v[i].time_finish > v[j].time_finish }
func (v VertexList) Swap(i, j int)      { v[i], v[j] = v[j], v[i] }

type Graph struct {
	adjancency_list map[int][]int
	vertex_list     map[int]*Vertex
	time_counter    int
}

func (graph *Graph) add_vertex(id int) {
	if graph.vertex_list == nil {
		graph.vertex_list = make(map[int]*Vertex)
	}
	graph.vertex_list[id] = &Vertex{
		id:            id,
		color:         WHITE,
		time_discover: 0,
		time_finish:   0,
		parent:        nil,
	}
}

func (graph *Graph) add_edge(from_id int, to_id int) {
	if graph.adjancency_list == nil {
		graph.adjancency_list = make(map[int][]int)
	}
	graph.adjancency_list[from_id] = append(graph.adjancency_list[from_id], to_id)
}

func (graph *Graph) init_time() {
	graph.time_counter = 0
}

func (graph *Graph) new_time() int {
	graph.time_counter++
	return graph.time_counter
}

func DFS(graph *Graph) {
	graph.init_time()

	for _, u_vertex := range graph.vertex_list {
		if u_vertex.color == WHITE {
			DFS_VISIT(graph, u_vertex)

			// As each vertex is finished, insert it onto the front of list.
			fmt.Println("Debug", u_vertex.id)
		}
	}
}

func DFS_VISIT(graph *Graph, u_vertex *Vertex) {
	u_vertex.time_discover = graph.new_time()
	u_vertex.color = GRAY
	u := u_vertex.id

	for _, v := range graph.adjancency_list[u] {
		v_vertex := graph.vertex_list[v]
		if v_vertex.color == WHITE {
			v_vertex.parent = u_vertex
			DFS_VISIT(graph, v_vertex)

			// As each vertex is finished, insert it onto the front of list.
			fmt.Println("Debug", v_vertex.id)
		}
	}

	u_vertex.color = BLACK
	u_vertex.time_finish = graph.new_time()
}

func TOPOLOGICAL_SORT(graph *Graph) VertexList {
	DFS(graph)

	var list VertexList
	for _, vertex := range graph.vertex_list {
		list = append(list, vertex)
	}

	sort.Sort(list)

	return list
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

	list := TOPOLOGICAL_SORT(graph)
	for _, vertex := range list {
		fmt.Printf("vertex id(%d)\tcolor(%d)\tdiscover(%d)\tfinish(%d)\t",
			vertex.id,
			vertex.color,
			vertex.time_discover,
			vertex.time_finish)

		if vertex.parent == nil {
			fmt.Printf("parent(nil)\n")
		} else {
			fmt.Printf("parent(%d)\n", vertex.parent.id)
		}
	}
}
