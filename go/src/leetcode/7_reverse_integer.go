package main

import (
	"fmt"
	"math"
)

func reverse(x int) int {
	if x == math.MinInt32 {
		return 0
	}

	s := 1
	if x == 0 {
		return 0
	} else if x < 0 {
		s = -1
		x = -x
	}

	r := 0
	for x > 0 {
		r *= 10
		r += x % 10
		if s == 1 && r > math.MaxInt32 {
			// overflow
			return 0
		} else if s == -1 && r > math.MaxInt32+1 {
			// overflow
			return 0
		}
		x /= 10
	}

	return r * s
}

func assert(expect int, result int) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %d, Get %d", expect, result))
	}
}

func main() {
	assert(1, reverse(1))
	assert(1, reverse(10))
	assert(1, reverse(100))
	assert(123, reverse(321))
	assert(-123, reverse(-321))
	assert(0, reverse(2147483647))
	assert(0, reverse(-2147483647))
}
