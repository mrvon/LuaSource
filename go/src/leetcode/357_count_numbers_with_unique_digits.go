package main

import "fmt"

func count(n int, s map[int]bool) int {
	if n <= 0 {
		return 1
	}

	c := 0

	for i := 0; i <= 9; i++ {
		if !s[i] {
			s[i] = true
			c += count(n-1, s)
			s[i] = false
		}
	}

	return c
}

func countNumbersWithUniqueDigits(n int) int {
	if n == 0 {
		return 1
	}

	c := 0
	s := make(map[int]bool)

	for i := 1; i <= 9; i++ {
		s[i] = true
		c += count(n-1, s)
		s[i] = false
	}

	c += countNumbersWithUniqueDigits(n - 1)

	return c
}

func assert(expect int, result int) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %d, Get %d", expect, result))
	}
}

func main() {
	assert(1, countNumbersWithUniqueDigits(0))
	assert(10, countNumbersWithUniqueDigits(1))
	assert(91, countNumbersWithUniqueDigits(2))
	assert(739, countNumbersWithUniqueDigits(3))
	assert(5275, countNumbersWithUniqueDigits(4))
	assert(32491, countNumbersWithUniqueDigits(5))
	assert(168571, countNumbersWithUniqueDigits(6))
}
