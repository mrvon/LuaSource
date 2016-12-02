package main

import "fmt"

// Naive brute force
func strStr(haystack string, needle string) int {
	h := []byte(haystack)
	n := []byte(needle)

	for i := 0; i <= len(h)-len(n); i++ {
		is_same := true
		for j := 0; j < len(n); j++ {
			if h[i+j] != n[j] {
				is_same = false
				break
			}
		}
		if is_same {
			return i
		}
	}
	return -1
}

// KMP
func kmp_strStr(haystack string, needle string) int {
	return -1
}

func assert(expect int, result int) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %d, Get %d", expect, result))
	}
}

func main() {
	assert(-1, strStr("hell", "hello"))
	assert(0, strStr("hello", "hello"))
	assert(-1, strStr("hello", " hello"))
	assert(1, strStr(" hello", "hello"))
	assert(6, strStr("world hello", "hello"))
	assert(-1, strStr("world ello", "hello"))
}
