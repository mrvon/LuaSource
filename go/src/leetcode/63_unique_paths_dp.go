package main

import "fmt"

// Dynamic Programming

func uniquePathsWithObstacles(obstacleGrid [][]int) int {
	var M [100][100]int
	m := len(obstacleGrid)
	n := len(obstacleGrid[0])

	if obstacleGrid[0][0] == 0 {
		M[0][0] = 1
	}

	for j := 1; j < n; j++ {
		if obstacleGrid[0][j] == 0 {
			M[0][j] = M[0][j-1]
		}
	}

	for i := 1; i < m; i++ {
		if obstacleGrid[i][0] == 0 {
			M[i][0] = M[i-1][0]
		}
	}

	for i := 1; i < m; i++ {
		for j := 1; j < n; j++ {
			if obstacleGrid[i][j] == 0 {
				M[i][j] = M[i-1][j] + M[i][j-1]
			}
		}
	}

	return M[m-1][n-1]
}

func main() {
	fmt.Println(uniquePathsWithObstacles([][]int{{0, 0, 0}, {0, 1, 0}, {0, 0, 0}}))
	fmt.Println(uniquePathsWithObstacles([][]int{{1, 0}}))
}
