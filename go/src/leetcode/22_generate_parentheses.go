package main

import "fmt"

func next_permutation(arr []byte) bool {
	n := len(arr) - 1

	k := -1
	for i := n - 1; i >= 0; i-- {
		if arr[i] < arr[i+1] {
			k = i
			break
		}
	}

	// last permutation
	if k == -1 {
		return false
	}

	l := n
	for i := n; i > k; i-- {
		if arr[k] < arr[i] {
			l = i
			break
		}
	}

	arr[k], arr[l] = arr[l], arr[k]

	i := k + 1
	j := n
	for i < j {
		arr[i], arr[j] = arr[j], arr[i]
		i++
		j--
	}

	return true
}

func is_wellformed(str []byte) bool {
	c := 0
	for i := 0; i < len(str); i++ {
		if str[i] == '(' {
			c++
		} else if str[i] == ')' {
			c--
			if c < 0 {
				return false
			}
		}
	}
	return c == 0
}

func generateParenthesis(n int) []string {
	var arr []byte
	var result []string
	for i := 0; i < n; i++ {
		arr = append(arr, '(')
	}
	for i := 0; i < n; i++ {
		arr = append(arr, ')')
	}

	// This is must be well-formed
	result = append(result, string(arr))

	for next_permutation(arr) {
		if is_wellformed(arr) {
			result = append(result, string(arr))
		}
	}
	return result
}

func test(n int) {
	fmt.Printf("------------------------- %d\n", n)
	result := generateParenthesis(n)
	for i := 0; i < len(result); i++ {
		fmt.Println(result[i])
	}
}

func main() {
	test(0)
	test(1)
	test(2)
	test(3)
	test(4)
}
