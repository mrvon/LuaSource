package main

import "fmt"

func expand(s string, p int) string {
	var s1 string
	var s2 string
	var s3 string

	// p-1 && p as pair
	if p-1 >= 0 && s[p-1] == s[p] {
		l := p - 1
		r := p
		for l >= 0 && r < len(s) && s[l] == s[r] {
			l--
			r++
		}
		s1 = s[l+1 : r]
	}

	// p && p+1 as pair
	if p < len(s)-1 && s[p] == s[p+1] {
		l := p
		r := p + 1
		for l >= 0 && r < len(s) && s[l] == s[r] {
			l--
			r++
		}
		s2 = s[l+1 : r]
	}

	// p as middle single one
	l := p - 1
	r := p + 1
	for l >= 0 && r < len(s) && s[l] == s[r] {
		l--
		r++
	}
	s3 = s[l+1 : r]

	if len(s1) >= len(s2) && len(s1) >= len(s3) {
		return s1
	} else if len(s2) >= len(s1) && len(s2) >= len(s3) {
		return s2
	} else {
		return s3
	}
}

func longestPalindrome(s string) string {
	var longest string
	for i := 0; i < len(s); i++ {
		r := expand(s, i)
		if len(r) > len(longest) {
			longest = r
		}
	}
	return longest
}

func main() {
	fmt.Println(longestPalindrome(""))
	fmt.Println(longestPalindrome("a"))
	fmt.Println(longestPalindrome("ab"))
	fmt.Println(longestPalindrome("cab"))
	fmt.Println(longestPalindrome("abbd"))
	fmt.Println(longestPalindrome("acbbcd"))
}
