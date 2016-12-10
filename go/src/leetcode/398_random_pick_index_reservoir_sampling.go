// Reservoir Samping solution
// https://en.wikipedia.org/wiki/Reservoir_sampling
package main

import (
	"fmt"
	"math/rand"
)

type Solution struct {
	nums []int
}

func Constructor(nums []int) Solution {
	return Solution{
		nums: nums,
	}
}

func (this *Solution) Pick(target int) int {
	n := 0
	j := 0

	for i := 0; i < len(this.nums); i++ {
		c := this.nums[i]
		if c != target {
			continue
		}

		r := rand.Int() % (j + 1)
		if r >= j {
			n = i
		}
		j++
	}

	return n
}

/**
 * Your Solution object will be instantiated and called as such:
 * obj := Constructor(nums);
 * param_1 := obj.Pick(target);
 */

func main() {
	nums := []int{1, 2, 3, 3, 3}
	obj := Constructor(nums)
	fmt.Println(obj.Pick(3))
	fmt.Println(obj.Pick(3))
	fmt.Println(obj.Pick(3))
	fmt.Println(obj.Pick(1))
	fmt.Println(obj.Pick(1))
	fmt.Println(obj.Pick(1))
}
