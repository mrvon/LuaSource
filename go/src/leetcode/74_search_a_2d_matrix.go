package main

import "fmt"

func searchMatrix(matrix [][]int, target int) bool {
	// binary search to find row
	sr := 0
	er := len(matrix) - 1

	left_bound := 0

	for sr <= er {
		mid := (sr + er) / 2
		v := matrix[mid][0]
		if target == v {
			return true
		} else if target < v {
			er = mid - 1
		} else {
			// target > v
			left_bound = mid
			sr = mid + 1
		}
	}

	sc := 0
	ec := len(matrix[left_bound]) - 1

	for sc <= ec {
		mid := (sc + ec) / 2
		v := matrix[left_bound][mid]
		if target == v {
			return true
		} else if target < v {
			ec = mid - 1
		} else {
			sc = mid + 1
		}
	}

	return false
}

func main() {
	fmt.Println(searchMatrix([][]int{
		{1, 3, 5, 7},
		{10, 11, 16, 20},
		{23, 30, 35, 50},
	}, 3))

	fmt.Println(searchMatrix([][]int{
		{1, 3, 5, 7},
		{10, 11, 16, 20},
		{23, 30, 35, 50},
	}, 2))
}
