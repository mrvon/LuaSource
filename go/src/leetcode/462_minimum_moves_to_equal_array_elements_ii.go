package main

import (
	"fmt"
	"sort"
)

type List []int

func (v List) Len() int {
	return len(v)
}

func (v List) Less(i, j int) bool {
	return v[i] < v[j]
}

func (v List) Swap(i, j int) {
	v[i], v[j] = v[j], v[i]
}

func abs(x int, y int) int {
	if x >= y {
		return x - y
	} else {
		return y - x
	}
}

func minMoves2(nums []int) int {
	list := List(nums)
	sort.Sort(list)

	if len(list) <= 1 {
		return 0
	}

	mid := len(list) / 2

	moves := 0

	for i := 0; i < mid; i++ {
		moves += abs(list[mid], list[i])
	}

	for i := mid + 1; i < len(list); i++ {
		moves += abs(list[mid], list[i])
	}

	return moves
}

func main() {
	fmt.Println(minMoves2([]int{1, 2, 3}))
	fmt.Println(minMoves2([]int{1, 3, 2}))
	fmt.Println(minMoves2([]int{1, 2, 3, 4}))
	fmt.Println(minMoves2([]int{1, 2, 3, 7}))
}
