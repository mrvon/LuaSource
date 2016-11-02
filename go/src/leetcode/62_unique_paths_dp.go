package main

import "fmt"

// Dynamic Programming

func uniquePaths(m int, n int) int {
	var M [100][100]int

	for j := 0; j < n; j++ {
		M[0][j] = 1
	}

	for i := 0; i < m; i++ {
		M[i][0] = 1
	}

	for i := 1; i < m; i++ {
		for j := 1; j < n; j++ {
			M[i][j] = M[i-1][j] + M[i][j-1]
		}
	}

	return M[m-1][n-1]
}

func main() {
	fmt.Println(uniquePaths(1, 2))
	fmt.Println(uniquePaths(4, 5))
	fmt.Println(uniquePaths(6, 7))
	fmt.Println(uniquePaths(99, 99))
}
