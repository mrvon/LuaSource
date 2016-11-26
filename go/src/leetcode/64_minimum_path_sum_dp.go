package main

import "fmt"

// DP solution
// s[i][j] = min(s[i+1][j] + grid[i][j], s[i][j+1] + grid[i][j])

func min(x int, y int) int {
	if x <= y {
		return x
	} else {
		return y
	}
}

func minPathSum(grid [][]int) int {
	if len(grid) == 0 {
		return 0
	}

	max_i := len(grid) - 1
	max_j := len(grid[0]) - 1

	var s [][]int
	for i := 0; i < max_i+1; i++ {
		s = append(s, make([]int, max_j+1))
	}

	s[max_i][max_j] = grid[max_i][max_j]

	for i := max_i - 1; i >= 0; i-- {
		s[i][max_j] = s[i+1][max_j] + grid[i][max_j]
	}

	for j := max_j - 1; j >= 0; j-- {
		s[max_i][j] = s[max_i][j+1] + grid[max_i][j]
	}

	for i := max_i - 1; i >= 0; i-- {
		for j := max_j - 1; j >= 0; j-- {
			s[i][j] = min(s[i+1][j]+grid[i][j], s[i][j+1]+grid[i][j])
		}
	}

	return s[0][0]
}

func main() {
	fmt.Println(minPathSum([][]int{
		{1, 2, 3, 4},
		{5, 6, 7, 8},
		{9, 10, 11, 12},
		{13, 14, 15, 16},
	}))
}
