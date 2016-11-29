package main

import "fmt"

func singleNumber(nums []int) int {
	for i := 1; i < len(nums); i++ {
		nums[0] ^= nums[i]
	}
	return nums[0]
}

func main() {
	fmt.Println(singleNumber([]int{1, 1, 3, 3, 2}))
	fmt.Println(singleNumber([]int{5, 2, 3, 3, 2}))
}
