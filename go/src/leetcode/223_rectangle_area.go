package main

import "fmt"

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

func computeArea(A int, B int, C int, D int, E int, F int, G int, H int) int {
	area := (C-A)*(D-B) + (H-F)*(G-E)

	// no overlap
	if A >= G || C <= E || B >= H || D <= F {
		return area
	}

	// have overlap
	return area - (min(C, G)-max(A, E))*(min(D, H)-max(B, F))
}

func assert(expect int, result int) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %d, Get %d", expect, result))
	}
}

func main() {
	assert(16, computeArea(-2, -2, 2, 2, -2, -2, 2, 2))
}
