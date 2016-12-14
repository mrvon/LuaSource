package main

import (
	"fmt"
	"sort"
)

func fourSum(nums []int, target int) [][]int {
	var result [][]int
	n := len(nums)
	sort.Ints(nums)

	i := 0

	for i < n-3 {
		j := i + 1
		for j < n-2 {
			k := j + 1
			for k < n-1 {
				l := k + 1
				for l < n {
					if nums[i]+nums[j]+nums[k]+nums[l] == target {
						result = append(result, []int{nums[i], nums[j], nums[k], nums[l]})
					}
					l++
					for l < n && nums[l-1] == nums[l] {
						l++
					}
				}
				k++
				for k < n-1 && nums[k-1] == nums[k] {
					k++
				}
			}
			j++
			for j < n-2 && nums[j-1] == nums[j] {
				j++
			}
		}
		i++
		for i < n-3 && nums[i-1] == nums[i] {
			i++
		}
	}

	return result
}

func main() {
	fmt.Println(fourSum([]int{1, 0, -1, 0, -2, 2}, 0))
}
