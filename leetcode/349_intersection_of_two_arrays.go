package main

import "fmt"

func intersection(nums1 []int, nums2 []int) []int {
	var num []int

	set1 := make(map[int]bool)
	set2 := make(map[int]bool)

	// set1 for fast search
	for _, i := range nums1 {
		set1[i] = true
	}

	// set2 for store result
	for _, i := range nums2 {
		if set1[i] {
			set2[i] = true
		}
	}

	for i := range set2 {
		num = append(num, i)
	}

	return num
}

func main() {
	// Given nums1 = [1, 2, 2, 1], nums2 = [2, 2], return [2].
	fmt.Println(intersection([]int{1, 2, 2, 1}, []int{2, 2}))
}
