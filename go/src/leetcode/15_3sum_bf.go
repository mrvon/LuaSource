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
		j := i + 1
		for j < n {
			k := j + 1
			for k < n {
				if nums[i]+nums[j]+nums[k] == 0 {
					result = append(result, []int{nums[i], nums[j], nums[k]})
				}
				// next k
				k++
				// skip same element
				for k < n && nums[k-1] == nums[k] {
					k++
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
