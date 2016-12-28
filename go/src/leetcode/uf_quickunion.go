// Quick union implementation (Slow find)
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
	for p != uf.id[p] {
		p = uf.id[p]
	}
	return p
}

func (uf *UF) union(p int, q int) {
	// Give p and q the same root.
	p_root := uf.find(p)
	q_root := uf.find(q)

	if p_root == q_root {
		return
	}

	uf.id[p_root] = q_root
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
