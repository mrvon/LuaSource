// weighted quick union implementation
package main

import (
	"fmt"
	"time"
)

type UF struct {
	id    []int // parent link (site indexed)
	sz    []int // size of  component for roots (site indexed)
	count int   // number of components
}

func new_uf(n int) *UF {
	uf := &UF{}
	uf.id = make([]int, n)
	uf.sz = make([]int, n)
	for i := 0; i < len(uf.id); i++ {
		uf.id[i] = i
		uf.sz[i] = 1
	}
	uf.count = n
	return uf
}

func (uf *UF) connected(p int, q int) bool {
	return uf.find(p) == uf.find(q)
}

func (uf *UF) find(p int) int {
	// Follow links to find a root.
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

	// Make smaller root point to larger one.
	if uf.sz[p_root] < uf.sz[q_root] {
		// p links to q
		uf.id[p_root] = q_root
		uf.sz[q_root] += uf.sz[p_root]
	} else {
		// q links to p
		uf.id[q_root] = p_root
		uf.sz[p_root] += uf.sz[q_root]
	}

	uf.count--
}

func main() {
	n := 0
	_, err := fmt.Scanf("%d", &n)
	if err != nil {
		return
	}

	var pair []int
	p := 0
	q := 0
	for {
		_, err := fmt.Scanf("%d %d", &p, &q)
		if err != nil {
			break
		}
		pair = append(pair, p)
		pair = append(pair, q)
	}

	start := time.Now()

	uf := new_uf(n)
	for i := 0; i < len(pair); i += 2 {
		p := pair[i]
		q := pair[i+1]

		if uf.connected(p, q) {
			continue
		}
		uf.union(p, q)
	}

	fmt.Println(uf.count, "components")
	fmt.Printf("use time(%s)\n", time.Since(start))
}
