package main

import "fmt"

func abs(x int) int {
	if x >= 0 {
		return x
	} else {
		return -x
	}
}

func solve(buf []int, k int, n int) int {
	solution_count := 0

	if k == n {
		// already place all queen
		return 1
	}

	for i := 0; i < n; i++ {
		// try to place new queen in BOARD(k, i)
		is_valid := true

		// check whether if new queen conflict with the queens which already placed
		for j := 0; j < k; j++ {
			// new queen (k, i) - old queen (j, buf[j)

			// check column
			if i == buf[j] {
				is_valid = false
				break
			}

			// check diagonal
			if abs(k-j) == abs(i-buf[j]) {
				is_valid = false
				break
			}
		}

		if is_valid {
			// OK, just place new queen in BOARD(k, i)
			buf[k] = i
			// Place next queen in the next row
			solution_count += solve(buf, k+1, n)
		}
	}

	return solution_count
}

func totalNQueens(n int) int {
	return solve(make([]int, n), 0, n)
}

func main() {
	fmt.Println(totalNQueens(0))
	fmt.Println(totalNQueens(1))
	fmt.Println(totalNQueens(2))
	fmt.Println(totalNQueens(3))
	fmt.Println(totalNQueens(4))
	fmt.Println(totalNQueens(8))
}
