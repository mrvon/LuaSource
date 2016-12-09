package main

import "fmt"

func __calculate(s string, i *int) int {
	var op byte
	result := 0

	for *i < len(s) {
		c := s[*i]
		if c == ' ' {
			// skip whitespace
			(*i)++
			continue
		} else if c >= '0' && c <= '9' {
			// integer
			num := 0
			for *i < len(s) && s[*i] >= '0' && s[*i] <= '9' {
				num *= 10
				num += int(s[*i] - '0')
				(*i)++
			}
			if op == '+' {
				result += num
			} else if op == '-' {
				result -= num
			} else {
				result = num
			}
		} else if c == '(' {
			// start sub-expression
			(*i)++
			if op == '+' {
				result += __calculate(s, i)
			} else if op == '-' {
				result -= __calculate(s, i)
			} else {
				result = __calculate(s, i)
			}
		} else if c == ')' {
			// end sub-expression
			(*i)++
			return result
		} else {
			// plus or minus
			(*i)++
			op = c
		}
	}

	// real all input
	return result
}

func calculate(s string) int {
	i := 0
	return __calculate(s, &i)
}

func assert(expect int, result int) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %d, Get %d", expect, result))
	}
}

func main() {
	assert(2, calculate("1 + 1"))
	assert(6, calculate("1 + 2 + 3"))
	assert(3, calculate("2-1 + 2 "))
	assert(2, calculate("(1 + 1)"))
	assert(0, calculate("(1 + 1) - 2"))
	assert(1, calculate("1"))
	assert(1, calculate("(1)"))
	assert(23, calculate("(1+(4+5+2)-3)+(6+8)"))
}
