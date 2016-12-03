package main

import "fmt"

func longestCommonPrefix(strs []string) string {
	if len(strs) == 0 {
		return ""
	} else if len(strs) == 1 {
		return strs[0]
	}

	i := 0
	for i = 0; i < len(strs[0]); i++ {
		c := strs[0][i]
		for j := 1; j < len(strs); j++ {
			if i >= len(strs[j]) {
				// not including i
				return string(strs[0][:i])
			}
			if c != strs[j][i] {
				// not including i
				return string(strs[0][:i])
			}
		}
	}

	// entirely strs[0]
	return string(strs[0])
}

func assert(expect string, result string) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %s, Get %s", expect, result))
	}
}

func main() {
	assert("", longestCommonPrefix([]string{}))
	assert("hell", longestCommonPrefix([]string{
		"hell",
	}))
	assert("hell", longestCommonPrefix([]string{
		"hello",
		"hell",
	}))
	assert("hel", longestCommonPrefix([]string{
		"hello",
		"hel",
		"hell",
	}))
	assert("", longestCommonPrefix([]string{
		"hel",
		"hell",
		"aello",
	}))
}
