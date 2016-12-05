package main

import "fmt"

// Run time complexity should be O(log(m+n)).
func findMedianSortedArrays(nums1 []int, nums2 []int) float64 {
	// TODO
	return 0
}

// Naive solution for test, Run time complexity is O(m+n)
func median(nums1 []int, nums2 []int) float64 {
	nums := make([]int, len(nums1)+len(nums2))
	i := 0
	j := 0
	k := 0
	for i < len(nums1) && j < len(nums2) {
		if nums1[i] <= nums2[j] {
			nums[k] = nums1[i]
			k++
			i++
		} else {
			nums[k] = nums2[j]
			k++
			j++
		}
	}
	for i < len(nums1) {
		nums[k] = nums1[i]
		k++
		i++
	}
	for j < len(nums2) {
		nums[k] = nums2[j]
		k++
		j++
	}

	mid := len(nums) / 2

	if len(nums)%2 == 0 {
		return float64(float64(nums[mid-1]+nums[mid]) / 2.0)
	} else {
		return float64(nums[mid])
	}
}

func assert(expect float64, result float64) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %f, Get %f", expect, result))
	}
}

func main() {
	assert(1.0, median([]int{1}, []int{}))
	assert(2.0, median([]int{}, []int{2}))
	assert(1.5, median([]int{1}, []int{2}))
	assert(2.0, median([]int{1, 3}, []int{2}))
	assert(2.5, median([]int{1, 2}, []int{3, 4}))
	assert(2.0, median([]int{1, 2}, []int{1, 2, 3}))
	assert(3.5, median([]int{3, 4, 5}, []int{1, 2, 7}))
	assert(5.5, median([]int{1, 3, 5, 7, 9}, []int{2, 4, 6, 8, 10}))
}
