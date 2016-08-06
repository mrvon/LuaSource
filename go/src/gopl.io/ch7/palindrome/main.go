package main

import (
	"fmt"
	"sort"
)

type ByteSlice []byte

func (s ByteSlice) Len() int {
	return len(s)
}

func (s ByteSlice) Less(i, j int) bool {
	return s[i] < s[j]
}

func (s ByteSlice) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}

func IsPalindrome(s sort.Interface) bool {
	len := s.Len()
	for i := 0; i < len/2; i++ {
		j := len - 1 - i
		if s.Less(i, j) || s.Less(j, i) {
			return false
		}
	}
	return true
}

func main() {
	fmt.Println(IsPalindrome(ByteSlice([]byte("AEIOU"))))
	fmt.Println(IsPalindrome(ByteSlice([]byte("AEIEA"))))
	fmt.Println(IsPalindrome(ByteSlice([]byte("Hello World"))))
	fmt.Println(IsPalindrome(ByteSlice([]byte("Hello olleH"))))
}
