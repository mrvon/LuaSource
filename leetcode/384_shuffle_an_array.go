// Fisher–Yates_shuffle
//
// To shuffle an array a of n elements (indices 0..n-1):
//
// for i from n−1 downto 1 do
//      j ← random integer such that 0 ≤ j ≤ i
//      exchange a[j] and a[i]

package main

import (
	"fmt"
	"math/rand"
)

type Solution struct {
	base []int
	buff []int
}

func Constructor(nums []int) Solution {
	var s Solution

	for i := 0; i < len(nums); i++ {
		s.base = append(s.base, nums[i])
		s.buff = append(s.buff, nums[i])
	}

	return s
}

/** Resets the array to its original configuration and return it. */
func (this *Solution) Reset() []int {
	for i := 0; i < len(this.base); i++ {
		this.buff[i] = this.base[i]
	}
	return this.buff
}

/** Returns a random shuffling of the array. */
func (this *Solution) Shuffle() []int {
	s := len(this.buff)
	if s <= 1 {
		return this.buff
	}

	i := s - 1

	for i > 0 {
		r := rand.Int() % (i + 1)
		// swap
		temp := this.buff[i]
		this.buff[i] = this.buff[r]
		this.buff[r] = temp
		i--
	}

	return this.buff
}

/**
 * Your Solution object will be instantiated and called as such:
 * obj := Constructor(nums);
 * param_1 := obj.Reset();
 * param_2 := obj.Shuffle();
 */

func main() {
	obj := Constructor([]int{1, 2, 3})
	for i := 1; i < 20; i++ {
		fmt.Println(obj.Reset())
		fmt.Println(obj.Shuffle())
	}
}
