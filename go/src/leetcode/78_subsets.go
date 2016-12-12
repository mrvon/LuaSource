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

func subsets(nums []int) [][]int {
	var sets [][]int

	n := len(nums)

	for i := 0; i <= n; i++ {
		c := combine(n, i)
		for j := 0; j < len(c); j++ {
			var set []int
			for k := 0; k < len(c[j]); k++ {
				set = append(set, nums[c[j][k]-1])
			}
			sets = append(sets, set)
		}
	}

	return sets
}

func main() {
	fmt.Println(subsets([]int{}))
	fmt.Println(subsets([]int{1}))
	fmt.Println(subsets([]int{1, 2}))
	fmt.Println(subsets([]int{1, 2, 3}))
}
