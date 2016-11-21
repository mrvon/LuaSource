package main

import "fmt"

func minMoves(nums []int) int {
	min := nums[0]

	for i := 1; i < len(nums); i++ {
		if nums[i] < min {
			min = nums[i]
		}
	}

	count := 0

	for i := 0; i < len(nums); i++ {
		count += (nums[i] - min)
	}

	return count
}

func main() {
	fmt.Println(minMoves([]int{1, 2, 3}))
}
