package main

import (
	"fmt"
	"math"
)

func __minPathSum(grid [][]int, x int, y int, cur int, min *int) {
	max_x := len(grid) - 1
	max_y := len(grid[0]) - 1

	if x == max_x && y == max_y {
		*min = cur
	}

	// Move down
	if x+1 <= max_x {
		next := cur + grid[x+1][y]
		if next < *min {
			__minPathSum(grid, x+1, y, next, min)
		}
	}

	// Move right
	if y+1 <= max_y {
		next := cur + grid[x][y+1]
		if next < *min {
			__minPathSum(grid, x, y+1, next, min)
		}
	}
}

func minPathSum(grid [][]int) int {
	if len(grid) == 0 {
		return 0
	}

	min := math.MaxInt32
	__minPathSum(grid, 0, 0, grid[0][0], &min)
	return min
}

func main() {
	fmt.Println(minPathSum([][]int{
		{1, 2, 3, 4},
		{5, 6, 7, 8},
		{9, 10, 11, 12},
		{13, 14, 15, 16},
	}))
}
