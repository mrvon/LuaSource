package main

import "fmt"

func removeDuplicates(nums []int) int {
	if len(nums) == 0 {
		return 0
	}

	l_range := 0
	r_range := 0

	for i := 1; i < len(nums); {
		if nums[r_range] == nums[i] {
			if r_range-l_range >= 1 {
				copy(nums[i:], nums[i+1:])
				nums = nums[:len(nums)-1]
			} else {
				r_range++
				i++
			}
		} else {
			l_range = i
			r_range = i
			i++
		}
	}

	return len(nums)
}

func main() {
	arr := []int{1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 6}
	fmt.Println(removeDuplicates(arr))
	fmt.Println(arr)
}
