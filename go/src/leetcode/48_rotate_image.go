package main

import "fmt"

// Rotate the image by 90 degrees (clockwise)
func rotate(matrix [][]int) {
	var temp [][]int
	for i := 0; i < len(matrix); i++ {
		temp = append(temp, []int{})
		for j := 0; j < len(matrix); j++ {
			temp[i] = append(temp[i], matrix[i][j])
		}
	}
	for i := 0; i < len(matrix); i++ {
		for j := 0; j < len(matrix[i]); j++ {
			m := j
			n := len(matrix[i]) - 1 - i
			matrix[m][n] = temp[i][j]
		}
	}
}

// In place solution
func inplace_rotate(matrix [][]int) {
	for i := 0; i < len(matrix); i++ {
		for j := 0; j < len(matrix[i])/2; j++ {
			m := i
			n := len(matrix[i]) - 1 - j
			// swap
			matrix[i][j], matrix[m][n] = matrix[m][n], matrix[i][j]
		}
	}

	for i := 0; i < len(matrix); i++ {
		for j := 0; j < len(matrix[i]); j++ {
			if i+j < len(matrix)-1 {
				m := len(matrix[i]) - 1 - j
				n := len(matrix[i]) - 1 - i
				// swap
				matrix[i][j], matrix[m][n] = matrix[m][n], matrix[i][j]
			}
		}
	}
}

func main() {
	m1 := [][]int{{1}}
	inplace_rotate(m1)
	fmt.Println(m1)

	m2 := [][]int{{1, 2}, {3, 4}}
	inplace_rotate(m2)
	fmt.Println(m2)

	m3 := [][]int{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}
	inplace_rotate(m3)
	fmt.Println(m3)
}
