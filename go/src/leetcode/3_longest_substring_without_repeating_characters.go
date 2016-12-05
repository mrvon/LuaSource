// Sliding Window Optimized

package main

import "fmt"

func lengthOfLongestSubstring(s string) int {
	if len(s) <= 1 {
		return len(s)
	}

	unique := make(map[byte]bool)
	max := 0
	l := 0
	j := 0 // left range

	for i := j; i < len(s); {
		if !unique[s[i]] {
			unique[s[i]] = true
			l++
			i++
		} else {
			// left range move forward
			unique[s[j]] = false
			j++
			l--
		}

		if l > max {
			max = l
		}
	}

	return max
}

func assert(expect int, result int) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %d, Get %d", expect, result))
	}
}

func main() {
	assert(0, lengthOfLongestSubstring(""))
	assert(1, lengthOfLongestSubstring("a"))
	assert(1, lengthOfLongestSubstring("aa"))
	assert(2, lengthOfLongestSubstring("ab"))
	assert(3, lengthOfLongestSubstring("abc"))
	assert(4, lengthOfLongestSubstring("abcd"))
	assert(3, lengthOfLongestSubstring("abcabcbb"))
	assert(1, lengthOfLongestSubstring("bbbbb"))
	assert(3, lengthOfLongestSubstring("pwwkew"))
	assert(5, lengthOfLongestSubstring("anviaj"))
}
