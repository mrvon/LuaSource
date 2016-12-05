package main

import "fmt"

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

func _combine(arr []int, k int) [][]int {
	return __combine([][]int{}, arr, []int{}, k)
}

func combine(n int, k int) [][]int {
	var arr []int
	for i := 1; i <= n; i++ {
		arr = append(arr, i)
	}
	return _combine(arr, k)
}

func main() {
	fmt.Println(combine(4, 2))
}
