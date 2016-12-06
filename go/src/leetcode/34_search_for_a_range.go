package main

import "fmt"

func searchRange(nums []int, target int) []int {
	s := -1
	e := -1

	i := 0
	j := len(nums) - 1
	for i <= j {
		m := i + (j-i)/2
		if target < nums[m] {
			j = m - 1
		} else if target > nums[m] {
			i = m + 1
		} else {
			s = m
			e = m
			break
		}
	}

	if s == -1 {
		return []int{
			s, e,
		}
	}

	for s > 0 {
		if nums[s-1] != target {
			break
		}
		s--
	}

	for e < len(nums)-1 {
		if nums[e+1] != target {
			break
		}
		e++
	}

	return []int{
		s, e,
	}
}

func main() {
	fmt.Println(searchRange([]int{}, 0))
	fmt.Println(searchRange([]int{0}, 0))
	fmt.Println(searchRange([]int{1}, 0))
	fmt.Println(searchRange([]int{5, 7, 7, 8, 8, 10}, 8))
	fmt.Println(searchRange([]int{5, 7, 7, 8, 8, 10}, 9))
}
