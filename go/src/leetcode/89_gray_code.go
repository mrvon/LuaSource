package main

import "fmt"

func __grayCode(n int) []string {
	var code_list []string

	code_list = append(code_list, "0")

	if n <= 0 {
		return code_list
	}

	code_list = append(code_list, "1")

	for l := 2; l < (1 << uint(n)); l = l << 1 {
		// copy previous code list and reverse append.
		for i := l - 1; i >= 0; i-- {
			code_list = append(code_list, code_list[i])
		}

		// append 0 to the first half
		for i := 0; i < l; i++ {
			code_list[i] = "0" + code_list[i]
		}

		// append 1 to the second half
		for i := l; i < 2*l; i++ {
			code_list[i] = "1" + code_list[i]
		}
	}

	return code_list
}

func binary_to_integer(s string) int {
	sum := 0
	for i := 0; i < len(s); i++ {
		sum = sum << 1
		if s[i] == '1' {
			sum |= 1
		}
	}
	return sum
}

func grayCode(n int) []int {
	var result []int
	code_list := __grayCode(n)
	for i := 0; i < len(code_list); i++ {
		result = append(result, binary_to_integer(code_list[i]))
	}
	return result
}

func main() {
	fmt.Println(grayCode(0))
	fmt.Println(grayCode(1))
	fmt.Println(grayCode(2))
	fmt.Println(grayCode(3))
	fmt.Println(grayCode(4))
}
