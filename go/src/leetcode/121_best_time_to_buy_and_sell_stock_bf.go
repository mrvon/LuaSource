// brute force
package main

import "fmt"

func auxMax(prices []int, j int, k int, m int) int {
	v := prices[k] - prices[j]
	if v > m {
		return v
	}

	return m
}

func maxProfit(prices []int) int {
	m := 0

	for i := 0; i < len(prices); i++ {
		for j := i + 1; j < len(prices); j++ {
			m = auxMax(prices, i, j, m)
		}
	}

	return m
}

func assert(expect int, result int) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %d, Get %d", expect, result))
	}
}

func main() {
	assert(0, maxProfit([]int{0}))
	assert(5, maxProfit([]int{7, 1, 5, 3, 6, 4}))
	assert(6, maxProfit([]int{1, 2, 3, 4, 5, 7}))
	assert(0, maxProfit([]int{7, 6, 5, 4, 3, 2}))
	assert(1, maxProfit([]int{2, 1, 2, 0, 1}))
	assert(2, maxProfit([]int{2, 1, 2, 1, 0, 1, 2}))
	assert(8, maxProfit([]int{3, 4, 2, 1, 2, 0, 1, 7, 8, 0, 1}))
}
