package main

import (
	"fmt"
	"math"
)

func isPalindrome(x int) bool {
	if x == 0 {
		return true
	} else if x < 0 {
		return false
	}

	r := reverse(x)
	if r == 0 {
		return false
	}

	if r == x {
		return true
	} else {
		return false
	}
}

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

func assert(expect bool, result bool) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %b, Get %b", expect, result))
	}
}

func main() {
	assert(true, isPalindrome(0))
	assert(false, isPalindrome(-1))
	assert(true, isPalindrome(1))
	assert(true, isPalindrome(11))
	assert(true, isPalindrome(121))
	assert(false, isPalindrome(123))
	assert(false, isPalindrome(-2147483648))

}
