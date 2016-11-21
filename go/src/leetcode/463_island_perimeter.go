package main

func overlap(grid [][]int, i int, j int, x int, y int) int {
	if i < 0 || i >= x {
		return 0
	} else if j < 0 || j >= y {
		return 0
	} else {
		if grid[i][j] == 0 {
			return 0
		} else {
			return 1
		}
	}
}

func islandPerimeter(grid [][]int) int {
	x := len(grid)
	y := len(grid[0])

	total := 0
	overl := 0

	for i := 0; i < x; i++ {
		for j := 0; j < y; j++ {
			if grid[i][j] == 1 {
				// LAND have four edge
				total += 4
				overl += overlap(grid, i-1, j, x, y)
				overl += overlap(grid, i, j-1, x, y)
				overl += overlap(grid, i+1, j, x, y)
				overl += overlap(grid, i, j+1, x, y)
			}
		}
	}

	return total - overl
}

func assert(b bool) {
	if !b {
		panic("assert failed")
	}
}

func main() {
	assert(islandPerimeter([][]int{{0, 1, 0, 0}, {1, 1, 1, 0}, {0, 1, 0, 0}, {1, 1, 0, 0}}) == 16)
}
