package main

import "fmt"

func longestPalindrome(s string) int {
	dict := make(map[rune]int)

	for _, r := range s {
		dict[r]++
	}

	var longest_rune rune
	var longest_size int = 0

	for _, r := range s {
		c := dict[r]
		if c%2 != 0 {
			if c > longest_size {
				longest_size = c
				longest_rune = r
			}
		}
	}

	delete(dict, longest_rune)

	len := longest_size

	for _, c := range dict {
		if c%2 == 0 {
			len += c
		} else {
			len += c - 1
		}
	}

	return len
}

func main() {
	fmt.Println(longestPalindrome("a"))
	fmt.Println(longestPalindrome("ab"))
	fmt.Println(longestPalindrome("ccc"))
	fmt.Println(longestPalindrome("acccb"))
	fmt.Println(longestPalindrome("accca"))
	fmt.Println(longestPalindrome("abccccdd"))
	fmt.Println(longestPalindrome("aaacccdddd"))
}
