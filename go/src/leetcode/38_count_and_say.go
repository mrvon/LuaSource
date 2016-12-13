package main

import "fmt"

func __count_and_say(s string) string {
	var n []byte

	i := 0

	for i < len(s) {
		j := i + 1
		for j < len(s) && s[i] == s[j] {
			j++
		}
		n = append(n, []byte(fmt.Sprintf("%d", j-i))...)
		n = append(n, s[i])
		i = j
	}

	return string(n)
}

func countAndSay(n int) string {
	word := "1"

	if n <= 0 {
		return ""
	} else if n == 1 {
		return word
	}

	for i := 2; i <= n; i++ {
		word = __count_and_say(word)
	}

	return word
}

func assert(expect string, result string) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %s, Get %s", expect, result))
	}
}

func main() {
	assert("1", countAndSay(1))
	assert("11", countAndSay(2))
	assert("21", countAndSay(3))
	assert("1211", countAndSay(4))
	assert("111221", countAndSay(5))
	assert("312211", countAndSay(6))
	assert("13112221", countAndSay(7))
	assert("1113213211", countAndSay(8))
	assert("31131211131221", countAndSay(9))
}
