// Quick find implementation (Slow union)
package main

import "fmt"

type UF struct {
	id    []int
	count int
}

func new_uf(n int) *UF {
	uf := &UF{}
	uf.id = make([]int, n)
	for i := 0; i < len(uf.id); i++ {
		uf.id[i] = i
	}
	uf.count = n
	return uf
}

func (uf *UF) connected(p int, q int) bool {
	return uf.find(p) == uf.find(q)
}

func (uf *UF) find(p int) int {
	// Quick find
	return uf.id[p]
}

func (uf *UF) union(p int, q int) {
	// Put p and q into the same component.
	p_id := uf.find(p)
	q_id := uf.find(q)

	// Nothing to do if p and q are already in the same component
	if p_id == q_id {
		return
	}

	// Rename p's component to q's name.
	for i := 0; i < len(uf.id); i++ {
		if uf.id[i] == p_id {
			uf.id[i] = q_id
		}
	}

	uf.count--
}

func main() {
	n := 0
	_, err := fmt.Scanf("%d", &n)
	if err != nil {
		return
	}

	uf := new_uf(n)
	p := 0
	q := 0
	for {
		_, err := fmt.Scanf("%d %d", &p, &q)
		if err != nil {
			break
		}
		if uf.connected(p, q) {
			continue
		}
		uf.union(p, q)
		fmt.Println(p, q)
	}
	fmt.Println(uf.count, "components")
}
