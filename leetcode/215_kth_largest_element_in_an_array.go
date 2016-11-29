package main

import "fmt"

// Index of mid element
func median_of_three(nums []int, left int, right int) int {
	if right-left <= 1 {
		return left
	} else {
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
}

// Three-way partitioning assumes zero-based array indexing.
// It uses three indices i, j and k,
// maintaining the invariant that i ≤ j.
// k holds the boundary of numbers less than mid.
// j is the position of number under consideration. And
// i is the boundary for the numbers greater than the mid.
func three_way_partition(nums []int, left int, right int, pivot int) (lrange int, rrange int) {
	i := left
	j := left
	k := right

	for j <= k {
		if nums[j] > pivot {
			nums[i], nums[j] = nums[j], nums[i]
			i++
			j++
		} else if nums[j] < pivot {
			nums[j], nums[k] = nums[k], nums[j]
			k--
		} else {
			j++
		}
	}

	lrange = i
	rrange = k
	return
}

func findKthLargest(nums []int, k int) int {
	left := 0
	right := len(nums) - 1

	// Adjust k to zero-based
	k = k - 1

	for left <= right {
		mid := median_of_three(nums, left, right)
		pivot := nums[mid]
		lrange, rrange := three_way_partition(nums, left, right, pivot)

		if k < lrange {
			right = lrange - 1
		} else if k > rrange {
			left = rrange + 1
		} else {
			return pivot
		}
	}

	// NOT found k element
	return 0
}

func main() {
	fmt.Println(findKthLargest([]int{1}, 1))
	fmt.Println(findKthLargest([]int{2, 1}, 1))
	fmt.Println(findKthLargest([]int{1, 2}, 2))
	fmt.Println(findKthLargest([]int{3, 2, 1, 10, 6, 4}, 1))
	fmt.Println(findKthLargest([]int{3, 2, 1, 10, 6, 4}, 2))
	fmt.Println(findKthLargest([]int{3, 2, 1, 10, 6, 4}, 3))
	fmt.Println(findKthLargest([]int{3, 2, 1, 10, 6, 4}, 4))
	fmt.Println(findKthLargest([]int{3, 2, 1, 10, 6, 4}, 5))
	fmt.Println(findKthLargest([]int{3, 2, 1, 10, 6, 4}, 6))
}
