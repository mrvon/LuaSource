package main

import "fmt"

// Recursive + Memorization Solution

type Key struct {
	m int
	n int
}

type Map map[Key]int

func (r Map) has(m int, n int) bool {
	k := Key{
		m: m,
		n: n,
	}
	_, ok := r[k]
	return ok
}

func (r Map) get(m int, n int) int {
	k := Key{
		m: m,
		n: n,
	}
	return r[k]
}

func (r Map) set(m int, n int, v int) {
	k := Key{
		m: m,
		n: n,
	}
	r[k] = v
}

func __uniquePaths(m int, n int, r Map) int {
	if m < 1 || n < 1 {
		r.set(m, n, 0)
		return 0
	} else if m == 1 && n == 1 {
		r.set(m, n, 1)
		return 1
	}

	if r.has(m, n) {
		return r.get(m, n)
	}

	right_count := 0
	if m > 1 {
		// Move Right
		if r.has(m-1, n) {
			right_count = r.get(m-1, n)
		} else {
			right_count = __uniquePaths(m-1, n, r)
			r.set(m-1, n, right_count)
		}
	}

	down_count := 0
	if n > 1 {
		// Move Down
		if r.has(m, n-1) {
			down_count = r.get(m, n-1)
		} else {
			down_count = __uniquePaths(m, n-1, r)
			r.set(m, n-1, down_count)
		}
	}

	count := right_count + down_count
	r.set(m, n, count)
	return count
}

func uniquePaths(m int, n int) int {
	return __uniquePaths(m, n, make(Map))
}

func main() {
	fmt.Println(uniquePaths(1, 2))
	fmt.Println(uniquePaths(4, 5))
	fmt.Println(uniquePaths(6, 7))
	fmt.Println(uniquePaths(99, 99))
}
