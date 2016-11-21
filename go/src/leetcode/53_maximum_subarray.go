package main

import "fmt"

func __max(n1 int, n2 int, n3 int) int {
	if n1 >= n2 && n1 >= n3 {
		return n1
	} else if n2 >= n1 && n2 >= n3 {
		return n2
	} else {
		return n3
	}
}

func __maxSubArray(nums []int, l int, r int) int {
	if l > r {
		return math.MinInt32
	} else if l == r {
		return nums[l]
	} else {
		// l < r
		m := l + (r-l)/2
		return __max(
			__maxSubArray(nums, l, m-1),
			__maxSubArray(nums, m+1, r),
			__crossArray(nums, l, m, r))
	}
}

func __crossArray(nums []int, l int, m int, r int) int {
	s1 := 0
	m1 := 0
	for i := m - 1; i >= l; i-- {
		s1 += nums[i]
		if s1 > m1 {
			m1 = s1
		}
	}

	s2 := 0
	m2 := 0
	for i := m + 1; i <= r; i++ {
		s2 += nums[i]
		if s2 > m2 {
			m2 = s2
		}
	}

	s := nums[m]
	if m1 > 0 {
		s += m1
	}
	if m2 > 0 {
		s += m2
	}

	return s
}

func maxSubArray(nums []int) int {
	return __maxSubArray(nums, 0, len(nums)-1)
}

func main() {
	fmt.Println(maxSubArray([]int{-2, 1, -3, 4, -1, 2, 1, -5, 4}))
	fmt.Println(maxSubArray([]int{-1}))
	fmt.Println(maxSubArray([]int{-1, -2}))
	fmt.Println(maxSubArray([]int{-2, 1, -3, 4, -1, 2, 1, -5, 4}))
	fmt.Println(maxSubArray([]int{0, -2, 0}))
}
