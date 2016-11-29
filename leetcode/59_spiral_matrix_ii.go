package main

import "fmt"

func generateMatrix(n int) [][]int {
	var matrix [][]int
	for i := 0; i < n; i++ {
		matrix = append(matrix, make([]int, n))
	}

	rs := 0
	re := n - 1
	cs := 0
	ce := n - 1

	id := 1

	for rs <= re && cs <= ce {
		// Move right
		for i := cs; i <= ce; i++ {
			matrix[rs][i] = id
			id++
		}
		rs++

		if rs > re {
			break
		}

		// Move down
		for i := rs; i <= re; i++ {
			matrix[i][ce] = id
			id++
		}
		ce--

		if cs > ce {
			break
		}

		// Move left
		for i := ce; i >= cs; i-- {
			matrix[re][i] = id
			id++
		}
		re--

		if rs > re {
			break
		}

		// Move up
		for i := re; i >= rs; i-- {
			matrix[i][cs] = id
			id++
		}
		cs++
	}

	return matrix
}

func main() {
	fmt.Println(generateMatrix(3))
}
