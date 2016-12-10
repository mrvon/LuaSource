package main

import (
	"fmt"
	"math/rand"
)

type Solution struct {
	m map[int][]int
}

func Constructor(nums []int) Solution {
	m := make(map[int][]int)
	for i := 0; i < len(nums); i++ {
		n := nums[i]
		if m[n] == nil {
			m[n] = []int{i}
		} else {
			m[n] = append(m[n], i)
		}
	}
	return Solution{
		m: m,
	}
}

func (this *Solution) Pick(target int) int {
	index_arr := this.m[target]
	if index_arr == nil {
		return -1
	}

	r := rand.Int() % len(index_arr)
	return index_arr[r]
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
