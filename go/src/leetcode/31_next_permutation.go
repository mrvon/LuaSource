package main

import (
	"fmt"
	"sort"
)

func nextPermutation(nums []int) {
	n := len(nums) - 1

	k := -1
	for i := n - 1; i >= 0; i-- {
		if nums[i] < nums[i+1] {
			k = i
			break
		}
	}

	// last permutation
	if k == -1 {
		sort.Ints(nums)
		return
	}

	l := n
	for i := n; i > k; i-- {
		if nums[k] < nums[i] {
			l = i
			break
		}
	}

	nums[k], nums[l] = nums[l], nums[k]

	i := k + 1
	j := n
	for i < j {
		nums[i], nums[j] = nums[j], nums[i]
		i++
		j--
	}

	// OK
	return
}

func main() {
	nums := []int{3, 1, 2}
	nextPermutation(nums)
	fmt.Println(nums)
	nextPermutation(nums)
	fmt.Println(nums)
}
