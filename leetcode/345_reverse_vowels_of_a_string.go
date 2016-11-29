package main

func is_vowel(c byte) bool {
	if c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' ||
		c == 'A' || c == 'E' || c == 'I' || c == 'O' || c == 'U' {
		return true
	} else {
		return false
	}
}

func reverseVowels(s string) string {
	var index_list []int

	for i := 0; i < len(s); i++ {
		if is_vowel(s[i]) {
			index_list = append(index_list, i)
		}
	}

	i := 0
	j := len(index_list) - 1
	byte_list := []byte(s)
	for i < j {
		m := index_list[i]
		n := index_list[j]
		byte_list[m], byte_list[n] = byte_list[n], byte_list[m]
		i++
		j--
	}
	return string(byte_list)
}

func assert(b bool) {
	if !b {
		panic("assert failed")
	}
}

func main() {
	assert(reverseVowels("aA") == "Aa")
	assert(reverseVowels("hello") == "holle")
	assert(reverseVowels("leetcode") == "leotcede")
	assert(reverseVowels("Snug & raw was I ere I saw war & guns.") == "Snug & raw was I ere I saw war & guns.")
}
