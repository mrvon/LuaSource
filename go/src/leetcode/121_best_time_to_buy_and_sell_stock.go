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

func main() {
	prices := []int{7, 1, 5, 3, 6, 4}
	fmt.Println(maxProfit(prices))
}
