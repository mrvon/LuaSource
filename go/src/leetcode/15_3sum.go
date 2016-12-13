// Key: write down and found the rule.
package main

import (
	"fmt"
	"sort"
)

func threeSum(nums []int) [][]int {
	var result [][]int

	n := len(nums)

	sort.Ints(nums)

	i := 0
	for i < n {
		if nums[i] > 0 {
			break
		}

		j := i + 1
		for j < n {
			if nums[i]+nums[j] > 0 {
				break
			}

			l := j + 1 // left range
			r := n - 1 // right range
			// binary search
			target := -nums[i] - nums[j]
			for l <= r {
				m := l + (r-l)/2
				if target == nums[m] {
					result = append(result, []int{nums[i], nums[j], nums[m]})
					break
				} else if target < nums[m] {
					r = m - 1
				} else {
					l = m + 1
				}
			}
			// next j
			j++
			// skip same element
			for j < n && nums[j-1] == nums[j] {
				j++
			}
		}
		// next i
		i++
		// skip same element
		for i < n && nums[i-1] == nums[i] {
			i++
		}
	}

	return result
}

func main() {
	fmt.Println(threeSum([]int{}))
	fmt.Println(threeSum([]int{0}))
	fmt.Println(threeSum([]int{0, 0, 0}))
	fmt.Println(threeSum([]int{-1, 0, 1, 2, -1, -4}))
}
