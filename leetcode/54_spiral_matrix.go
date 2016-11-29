package main

import "fmt"

func spiralOrder(matrix [][]int) []int {
	var result []int

	if len(matrix) == 0 {
		return result
	}

	rs := 0                  // row start control line
	re := len(matrix) - 1    // row end control line
	cs := 0                  // column start control line
	ce := len(matrix[0]) - 1 // column end control line

	for rs <= re && cs <= ce {
		// Move right
		for j := cs; j <= ce; j++ {
			result = append(result, matrix[rs][j])
		}
		rs++

		if rs > re {
			break
		}

		// Move down
		for i := rs; i <= re; i++ {
			result = append(result, matrix[i][ce])
		}
		ce--

		if cs > ce {
			break
		}

		// Move left
		for j := ce; j >= cs; j-- {
			result = append(result, matrix[re][j])
		}
		re--

		if rs > re {
			break
		}

		// Move up
		for i := re; i >= rs; i-- {
			result = append(result, matrix[i][cs])
		}
		cs++
	}

	return result
}

func main() {
	fmt.Println(spiralOrder([][]int{{1, 2}}))
	fmt.Println(spiralOrder([][]int{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}))
}
