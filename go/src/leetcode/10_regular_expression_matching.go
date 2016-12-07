package main

import "fmt"

// '.' Matches any single character.
// '*' Matches zero or more of the preceding element.
// The matching should cover the entire input string (not partial).

func isMatch(s string, p string) bool {
	// TODO
	return true
}

func assert(expect bool, result bool) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %b, Get %b", expect, result))
	}
}

func main() {
	assert(false, isMatch("aa", "a"))
	assert(true, isMatch("aa", "aa"))
	assert(false, isMatch("aaa", "aa"))
	assert(true, isMatch("aa", "a*"))
	assert(true, isMatch("aa", ".*"))
	assert(true, isMatch("ab", ".*"))
	assert(true, isMatch("aab", "c*a*b"))
}
