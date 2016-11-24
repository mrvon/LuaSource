package main

import "fmt"

func searchMatrix(matrix [][]int, target int) bool {
	var right_bound int = -1

	for r := 0; r < len(matrix); r++ {
		s := 0
		e := 0

		if right_bound == -1 {
			e = len(matrix[r]) - 1
			right_bound = len(matrix[r]) - 1
		} else {
			e = right_bound
		}

		for s <= e {
			m := (s + e) / 2
			v := matrix[r][m]

			if target == v {
				return true
			} else if target < v {
				right_bound = m - 1
				e = m - 1
			} else {
				s = m + 1
			}
		}
	}

	return false
}

func main() {
	a1 := [][]int{
		{1, 3, 5, 7},
		{10, 11, 16, 20},
		{23, 30, 35, 50},
	}

	fmt.Println(searchMatrix(a1, 3))
	fmt.Println(searchMatrix(a1, 2))

	a2 := [][]int{
		{1, 4, 7, 11, 15},
		{2, 5, 8, 12, 19},
		{3, 6, 9, 16, 22},
		{10, 13, 14, 17, 24},
		{18, 21, 23, 26, 30},
	}

	fmt.Println(searchMatrix(a2, 5))
	fmt.Println(searchMatrix(a2, 20))
}
