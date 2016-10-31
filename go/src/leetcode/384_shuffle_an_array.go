package main

import (
	"fmt"
	"math/rand"
	"time"
)

type Solution struct {
	base []int
	buff []int
	rand *rand.Rand
}

func Constructor(nums []int) Solution {
	var s Solution

	s.rand = rand.New(rand.NewSource(time.Now().UTC().UnixNano()))

	for i := 0; i < len(nums); i++ {
		s.base = append(s.base, nums[i])
		s.buff = append(s.buff, nums[i])
	}

	return s
}

/** Resets the array to its original configuration and return it. */
func (this *Solution) Reset() []int {
	return this.base
}

/** Returns a random shuffling of the array. */
func (this *Solution) Shuffle() []int {
	s := len(this.buff)
	if s <= 1 {
		return this.buff
	}

	i := s - 1
	r := this.rand.Int() % s

	for r >= 0 {
		// swap
		temp := this.buff[i]
		this.buff[i] = this.buff[r]
		this.buff[r] = temp
		r--
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
	obj := Constructor([]int{1, 2, 3, 4, 5, 6})
	fmt.Println(obj.Shuffle())
	fmt.Println(obj.Reset())
	fmt.Println(obj.Shuffle())
}
