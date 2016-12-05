package main

import "fmt"

func combinations(dict map[byte]string, digits []byte, buff []byte, result []string) []string {
	m := dict[digits[0]]
	for i := 0; i < len(m); i++ {
		buff = append(buff, m[i])
		if len(digits) <= 1 {
			result = append(result, string(buff))
		} else {
			result = combinations(dict, digits[1:], buff, result)
		}
		buff = buff[:len(buff)-1]
	}
	return result
}

func letterCombinations(digits string) []string {
	var result []string

	if len(digits) == 0 {
		return result
	}

	dict := make(map[byte]string)
	dict['0'] = ""
	dict['1'] = ""
	dict['2'] = "abc"
	dict['3'] = "def"
	dict['4'] = "ghi"
	dict['5'] = "jkl"
	dict['6'] = "mno"
	dict['7'] = "pqrs"
	dict['8'] = "tuv"
	dict['9'] = "wxyz"

	var buff []byte
	result = combinations(dict, []byte(digits), buff, result)
	return result
}

func main() {
	fmt.Println(letterCombinations(""))
	fmt.Println(letterCombinations("0"))
	fmt.Println(letterCombinations("1"))
	fmt.Println(letterCombinations("2"))
	fmt.Println(letterCombinations("23"))
	fmt.Println(letterCombinations("234"))
}
