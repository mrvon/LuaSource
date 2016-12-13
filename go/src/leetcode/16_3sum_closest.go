package main

import (
	"fmt"
	"math"
	"sort"
)

func abs(x int) int {
	if x >= 0 {
		return x
	} else {
		return -x
	}
}

func threeSumClosest(nums []int, target int) int {
	closest := math.MaxInt32
	sum := 0
	n := len(nums)
	i := 0

	sort.Ints(nums)

	for i < n {
		j := i + 1
		for j < n {
			k := j + 1
			for k < n {
				r := nums[i] + nums[j] + nums[k]
				d := abs(r - target)
				if d < closest {
					closest = d
					sum = r
				}
				// next k
				k++
				for k < n && nums[k-1] == nums[k] {
					k++
				}
			}
			// next j
			j++
			for j < n && nums[j-1] == nums[j] {
				j++
			}
		}
		// next i
		i++
		for i < n && nums[i-1] == nums[i] {
			i++
		}
	}

	return sum
}

func main() {
	fmt.Println(threeSumClosest([]int{-1, 2, 1, -4}, 1))
}
