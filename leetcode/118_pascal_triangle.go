package main

import "fmt"

// [
// [1],
// [1,1],
// [1,2,1],
// [1,3,3,1],
// [1,4,6,4,1]
// ]

func generate(numRows int) [][]int {
	var result [][]int
	for i := 1; i <= numRows; i++ {
		line := []int{}
		if i == 1 {
			line = append(line, 1)
		} else if i == 2 {
			line = append(line, 1)
			line = append(line, 1)
		} else {
			for j := 0; j < i; j++ {
				if j == 0 || j == i-1 {
					line = append(line, 1)
				} else {
					line = append(line, result[i-2][j-1]+result[i-2][j])
				}
			}
		}
		result = append(result, line)
	}
	return result
}

func main() {
	fmt.Println(generate(5))
}
