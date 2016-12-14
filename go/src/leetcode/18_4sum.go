// beats 100%, 9ms
package main

import (
	"fmt"
	"sort"
)

func fourSum(nums []int, target int) [][]int {
	var result [][]int

	n := len(nums)

	if n < 4 {
		return result
	}

	sort.Ints(nums)

	max := nums[n-1]

	if 4*nums[0] > target || 4*max < target {
		// too large or too small
		return result
	}

	for i := 0; i < n; i++ {
		if i > 0 && nums[i] == nums[i-1] {
			// skip duplicate
			continue
		}

		if nums[i]+3*max < target {
			// too small
			continue
		}

		if 4*nums[i] > target {
			// too large
			break
		}

		result = threeSum(nums[i+1:], target-nums[i], result, nums[i])
	}

	return result
}

func threeSum(nums []int, target int, result [][]int, first int) [][]int {
	n := len(nums)

	if n < 3 {
		return result
	}

	max := nums[n-1]

	if 3*nums[0] > target || 3*max < target {
		// too large or too small
		return result
	}

	for i := 0; i < n; i++ {
		if i > 0 && nums[i] == nums[i-1] {
			// skip duplicate
			continue
		}

		if nums[i]+2*max < target {
			// too small
			continue
		}

		if 3*nums[i] > target {
			// too large
			break
		}

		result = twoSum(nums[i+1:], target-nums[i], result, first, nums[i])
	}

	return result
}

func twoSum(nums []int, target int, result [][]int, first int, second int) [][]int {
	n := len(nums)

	if n < 2 {
		return result
	}

	max := nums[n-1]

	if 2*nums[0] > target || 2*max < target {
		// too large or too small
		return result
	}

	for i := 0; i < n; i++ {
		if i > 0 && nums[i] == nums[i-1] {
			// skip duplicate
			continue
		}

		if nums[i]+max < target {
			// too small
			continue
		}

		if 2*nums[i] > target {
			// too large
			break
		}

		l := i + 1 // left range
		r := n - 1 // right range
		// binary search
		t := target - nums[i]
		for l <= r {
			m := l + (r-l)/2
			if t == nums[m] {
				result = append(result, []int{first, second, nums[i], nums[m]})
				break
			} else if t < nums[m] {
				r = m - 1
			} else {
				l = m + 1
			}
		}
	}

	return result
}

func main() {
	fmt.Println(fourSum([]int{1, 0, -1, 0, -2, 2}, 0))
	fmt.Println(fourSum([]int{-4, -3, -2, -1, 0, 0, 1, 2, 3, 4}, 0))
}
