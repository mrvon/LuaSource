package main

import (
	"fmt"
	"math"
)

type Pair struct {
	low  int
	high int
}

func min(x int, y int) int {
	if x <= y {
		return x
	} else {
		return y
	}
}

func max(x int, y int) int {
	if x >= y {
		return x
	} else {
		return y
	}
}

func guess(low int, high int, memorized map[Pair]int) int {
	count := high - low
	if count <= 0 {
		// less than or equal to one element
		return 0
	} else if count <= 1 {
		// two element, guess first one
		return low
	} else if count <= 2 {
		// three element, guess first one
		return low + 1
	}
	// otherwise

	// split
	m := math.MaxInt32

	for mid := low + 1; mid <= high-1; mid++ {
		g1, is_find := memorized[Pair{low: low, high: mid - 1}]
		if !is_find {
			g1 = guess(low, mid-1, memorized)
		}

		g2, is_find := memorized[Pair{low: mid + 1, high: high}]
		if !is_find {
			g2 = guess(mid+1, high, memorized)
		}

		c := mid + max(g1, g2)
		m = min(m, c)
	}

	memorized[Pair{low: low, high: high}] = m

	return m
}

func getMoneyAmount(n int) int {
	// Memorized
	memorized := make(map[Pair]int)
	return guess(1, n, memorized)
}

func assert(expect int, result int) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %d, Get %d", expect, result))
	}
}

func main() {
	assert(0, getMoneyAmount(1))
	assert(1, getMoneyAmount(2))
	assert(2, getMoneyAmount(3))
	assert(4, getMoneyAmount(4))
	assert(6, getMoneyAmount(5))
	assert(8, getMoneyAmount(6))
	assert(10, getMoneyAmount(7))
	assert(12, getMoneyAmount(8))
	assert(14, getMoneyAmount(9))
	assert(16, getMoneyAmount(10))
	assert(18, getMoneyAmount(11))
	assert(21, getMoneyAmount(12))
	assert(24, getMoneyAmount(13))
	assert(400, getMoneyAmount(100))
}
