package main

import "fmt"

func countSegments(s string) int {
	count := 0
	i := 0

	// skip all space
	for i < len(s) {
		if s[i] != ' ' {
			break
		}
		i++
	}

	for i < len(s) {
		count++

		// skip all non-space
		for i < len(s) {
			if s[i] == ' ' {
				break
			}
			i++
		}

		// skip all space
		for i < len(s) {
			if s[i] != ' ' {
				break
			}
			i++
		}
	}

	return count
}

func assert(expect int, result int) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %d, Get %d", expect, result))
	}
}

func main() {
	assert(5, countSegments("Hello, my name is John"))
	assert(0, countSegments(""))
	assert(0, countSegments(" "))
	assert(1, countSegments("a"))
	assert(1, countSegments("a "))
}
