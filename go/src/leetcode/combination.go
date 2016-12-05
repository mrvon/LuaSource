package main

import (
	"fmt"
)

func __combine(result [][]int, arr []int, buf []int, k int) [][]int {
	if k == 0 {
		new_buf := make([]int, len(buf))
		copy(new_buf, buf)
		result = append(result, new_buf)
		return result
	}

	for i := 0; i <= len(arr)-k; i++ {
		buf = append(buf, arr[i])
		result = __combine(result, arr[i+1:], buf, k-1)
		buf = buf[:len(buf)-1]
	}

	return result
}

func combine(arr []int, k int) [][]int {
	return __combine([][]int{}, arr, []int{}, k)
}

func main() {
	arr := []int{1, 2, 3, 4, 5}
	result := combine(arr, 3)
	for i := 0; i < len(result); i++ {
		fmt.Println(result[i])
	}
}
