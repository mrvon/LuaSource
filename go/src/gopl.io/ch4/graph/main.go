package main

import (
	"fmt"
)

var graph = make(map[string]map[string]bool)

func addEdge(from, to string) {
	edges := graph[from]
	if edges == nil {
		edges = make(map[string]bool)
		graph[from] = edges
	}
	edges[to] = true
}

func hasEdge(from, to string) bool {
	return graph[from][to]
}

func main() {
	addEdge("A", "B")
	addEdge("A", "C")
	addEdge("B", "C")
	addEdge("B", "D")

	fmt.Println(hasEdge("A", "B"))
	fmt.Println(hasEdge("A", "C"))
	fmt.Println(hasEdge("A", "D"))
	fmt.Println(hasEdge("B", "A"))
	fmt.Println(hasEdge("B", "D"))

	fmt.Println(graph)
}
