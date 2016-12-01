package main

import "fmt"

func missingNumber(nums []int) int {
	n := len(nums)

	if n == 0 {
		return 0
	}

	var s int64 = 0

	if n%2 == 0 {
		s = int64(n/2) * int64(n+1)
	} else {
		s = int64(n) * int64((n+1)/2)
	}

	for i := 0; i < n; i++ {
		s -= int64(nums[i])
	}

	return int(s)
}

func assert(expect int, result int) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %d, Get %d", expect, result))
	}
}

func main() {
	assert(1, missingNumber([]int{0}))
	assert(0, missingNumber([]int{1}))
	assert(1, missingNumber([]int{0, 2}))
	assert(2, missingNumber([]int{0, 1, 3}))
	assert(2, missingNumber([]int{0, 1, 3, 4}))
}
