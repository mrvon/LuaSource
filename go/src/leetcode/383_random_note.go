package main

import "fmt"

func canConstruct(ransomNote string, magazine string) bool {
	var dict = make(map[rune]int)
	for _, c := range magazine {
		dict[c]++
	}

	for _, c := range ransomNote {
		if dict[c] <= 0 {
			return false
		} else {
			dict[c]--
		}
	}

	return true
}

func main() {
	fmt.Println(canConstruct("Helo", "Hello"))
	fmt.Println(canConstruct("Heklo", "Hello"))
}
