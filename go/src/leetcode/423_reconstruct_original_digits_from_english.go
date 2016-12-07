package main

import (
	"fmt"
	"sort"
)

type ByteList []byte

func (l ByteList) Len() int {
	return len(l)
}

func (l ByteList) Less(i, j int) bool {
	return l[i] < l[j]
}

func (l ByteList) Swap(i, j int) {
	l[i], l[j] = l[j], l[i]
}

type Item struct {
	str string
	key byte
	num byte
}

func originalDigits(s string) string {
	// This permutation is intentionally to avoid conflict.
	digits := []Item{
		{str: "zero", key: 'z', num: '0'},
		{str: "eight", key: 'g', num: '8'},
		{str: "two", key: 'w', num: '2'},
		{str: "six", key: 'x', num: '6'},
		{str: "three", key: 't', num: '3'},
		{str: "seven", key: 's', num: '7'},
		{str: "five", key: 'v', num: '5'},
		{str: "four", key: 'f', num: '4'},
		{str: "nine", key: 'i', num: '9'},
		{str: "one", key: 'o', num: '1'},
	}

	char_map := make(map[byte]int)
	for i := 0; i < len(s); i++ {
		char_map[s[i]]++
	}

	var result []byte

	for i := 0; i < len(digits); i++ {
		item := digits[i]
		count := char_map[item.key]
		if count > 0 {
			for i := 0; i < len(item.str); i++ {
				char_map[item.str[i]] -= count
			}
			for i := 0; i < count; i++ {
				result = append(result, item.num)
			}
		}
	}

	bl := ByteList(result)
	sort.Sort(bl)

	return string(bl)
}

func assert(expect string, result string) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %s, Get %s", expect, result))
	}
}

func main() {
	assert("", originalDigits(""))
	assert("0", originalDigits("zero"))
	assert("012", originalDigits("owoztneoer"))
	assert("45", originalDigits("fviefuro"))
	assert("0123456", originalDigits("zeroonetwothreefourfivesix"))
	assert("01234567", originalDigits("zeroonetwothreefourfivesixseven"))
	assert("012345678", originalDigits("zeroonetwothreefourfivesixseveneight"))
	assert("0123456789", originalDigits("zeroonetwothreefourfivesixseveneightnine"))
}
