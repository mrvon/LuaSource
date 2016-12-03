package main

import (
	"fmt"
	"math"
)

func myAtoi(str string) int {
	b := []byte(str)
	s := 1
	n := 0
	i := 0

	// skip whitespace
	for i < len(b) && b[i] == ' ' {
		i++
	}

	// skip sign
	if i < len(b) && (b[i] == '+' || b[i] == '-') {
		if b[i] == '+' {
			s = 1
		} else {
			s = -1
		}
		i++
	}

	// skip leading zero
	if i < len(b) && (b[i] == '0') {
		i++
	}

	for i < len(b) {
		if b[i] >= '0' && b[i] <= '9' {
			n *= 10
			n += int(b[i] - '0')
			if s == 1 && n >= math.MaxInt32 {
				return math.MaxInt32
			} else if s == -1 && n >= math.MaxInt32+1 {
				return math.MinInt32
			}
		} else {
			break
		}
		i++
	}

	n *= s

	return n
}

func assert(expect int, result int) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %b, Get %b", expect, result))
	}
}

func main() {
	assert(0, myAtoi("a"))
	assert(1, myAtoi("1"))
	assert(1, myAtoi("1a"))
	assert(0, myAtoi(""))
	assert(0, myAtoi(" "))
	assert(1, myAtoi(" 1"))
	assert(1, myAtoi(" 1a"))
	assert(2147483647, myAtoi("2147483647"))
	assert(2147483647, myAtoi("2147483648"))
	assert(-2147483647, myAtoi("-2147483647"))
	assert(-2147483648, myAtoi("-2147483648"))
	assert(-2147483648, myAtoi("-2147483649"))
	assert(2147483647, myAtoi("9223372036854775809"))
	assert(-2147483648, myAtoi("-9223372036854775809"))
}
