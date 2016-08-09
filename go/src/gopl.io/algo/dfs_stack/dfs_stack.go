/*
The algorithm works on both directed and undirected graphs.
*/

package main

import (
	"bytes"
	"fmt"
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

type Graph struct {
	adjancency_list map[int][]int
	vertex_list     map[int]*Vertex
	time_counter    int

	debug_buffer bytes.Buffer
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

type Stack struct {
	S []int
}

func (S *Stack) push(id int) {
	S.S = append(S.S, id)
}

func (S *Stack) pop() (id int) {
	id = S.S[len(S.S)-1]
	S.S = S.S[:len(S.S)-1]
	return
}

func (S *Stack) isempty() bool {
	if len(S.S) == 0 {
		return true
	} else {
		return false
	}
}

func DFS(graph *Graph) {
	graph.init_time()
	var s Stack

	for _, u_vertex := range graph.vertex_list {
		if u_vertex.color == WHITE {
			s.push(u_vertex.id)
		}

		for !s.isempty() {
			u := s.pop()

			u_vertex := graph.vertex_list[u]

			if u_vertex.color == WHITE {
				u_vertex.time_discover = graph.new_time()
				u_vertex.color = GRAY
				fmt.Fprintf(&graph.debug_buffer, "(%d ", u)

				s.push(u)

				for _, v := range graph.adjancency_list[u] {
					v_vertex := graph.vertex_list[v]
					if v_vertex.color == WHITE {
						v_vertex.parent = u_vertex
						s.push(v_vertex.id)
					}
				}
			} else {
				fmt.Fprintf(&graph.debug_buffer, "%d) ", u)

				u_vertex.color = BLACK
				u_vertex.time_finish = graph.new_time()
			}
		}
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

	DFS(graph)

	fmt.Println(graph.debug_buffer.String())

	for _, vertex := range graph.vertex_list {
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
