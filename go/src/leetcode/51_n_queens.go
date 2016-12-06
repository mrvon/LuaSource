package main

import "fmt"

func abs(x int) int {
	if x >= 0 {
		return x
	} else {
		return -x
	}
}

func solve(solution_list [][]string, buf []int, k int, n int) [][]string {
	if k == n {
		// already place all queen
		var solution []string
		for i := 0; i < n; i++ {
			var t []byte
			for j := 0; j < n; j++ {
				if buf[i] == j {
					t = append(t, 'Q')
				} else {
					t = append(t, '.')
				}
			}
			solution = append(solution, string(t))
		}
		solution_list = append(solution_list, solution)
		return solution_list
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
			solution_list = solve(solution_list, buf, k+1, n)
		}
	}

	return solution_list
}

func solveNQueens(n int) [][]string {
	return solve([][]string{}, make([]int, n), 0, n)
}

func test(n int) {
	solution_list := solveNQueens(n)
	for i := 0; i < len(solution_list); i++ {
		solution := solution_list[i]
		for j := 0; j < len(solution); j++ {
			fmt.Println(solution[j])
		}
		fmt.Println("")
	}
}

func main() {
	test(0)
	test(1)
	test(8)
}
