package main

import "fmt"

func singleNumber(nums []int) int {
	x := 0
	for i := 0; i < 64; i++ {
		mask := 1 << uint(i)
		sum := 0
		for j := 0; j < len(nums); j++ {
			if nums[j]&mask != 0 {
				sum++
			}
		}
		if sum%3 != 0 {
			x |= mask
		}
	}
	return x
}

func main() {
	fmt.Println(singleNumber([]int{1, 1, 1, -1, 2, 2, 2}))
}
