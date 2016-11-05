package main

import "fmt"

func median_of_three(nums []int, left int, right int) int {
	if right-left <= 1 {
		return left
	}

	mid := left + (right-left)/2
	x := nums[left]
	y := nums[mid]
	z := nums[right]

	if x >= y && x <= z {
		return left
	} else if y >= x && y <= z {
		return mid
	} else {
		return right
	}
}

func three_way_partition(nums []int, left int, right int, pivot int) (lrange int, rrange int) {
	i := left
	j := left
	k := right

	for j <= k {
		if nums[j] < pivot {
			nums[i], nums[j] = nums[j], nums[i]
			i++
			j++
		} else if nums[j] > pivot {
			nums[k], nums[j] = nums[j], nums[k]
			k--
		} else {
			j++
		}
	}

	lrange = i
	rrange = k
	return
}

func __quick_sort(nums []int, left int, right int) {
	if right-left <= 0 {
		return
	}

	mid := median_of_three(nums, left, right)
	pivot := nums[mid]

	lrange, rrange := three_way_partition(nums, left, right, pivot)
	__quick_sort(nums, left, lrange-1)
	__quick_sort(nums, rrange+1, right)
}

func quick_sort(nums []int) {
	__quick_sort(nums, 0, len(nums)-1)
}

func test(nums []int) {
	fmt.Println(nums)
	quick_sort(nums)
	fmt.Println(nums)
}

func main() {
	test([]int{5, 6, 1, 2, 9, 10})
	test([]int{1, 1, 1, 1, 1, 2})
	test([]int{3, 1, 1, 1, 1, 1})
}
