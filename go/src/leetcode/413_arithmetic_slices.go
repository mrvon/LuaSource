package main

import "fmt"

func isArithmetic(A []int) bool {
	for i := 0; i <= len(A)-3; i++ {
		if (A[i+2] - A[i+1]) != (A[i+1] - A[i]) {
			return false
		}
	}
	return true
}

func numberOfArithmeticSlices(A []int) int {
	c := 0
	for i := 0; i <= len(A)-3; i++ {
		for j := i + 3; j <= len(A); j++ {
			if isArithmetic(A[i:j]) {
				c++
			}
		}
	}
	return c
}

func main() {
	fmt.Println(numberOfArithmeticSlices([]int{1, 4, 3, 4}))
}
