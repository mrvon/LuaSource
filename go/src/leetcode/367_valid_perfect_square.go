package main

import "fmt"

func isPerfectSquare(num int) bool {
	if num == 0 {
		return false
	} else if num == 1 {
		return true
	} else if num == 2 {
		return false
	} else {
		half := num / 2
		for i := 2; i <= half; i++ {
			if i*i == num {
				return true
			}
		}
		return false
	}
}

func assert(b bool) {
	if !b {
		panic("assert failed")
	}
}

func main() {
	assert(isPerfectSquare(1) == true)
	assert(isPerfectSquare(2) == false)
	assert(isPerfectSquare(3) == false)
	assert(isPerfectSquare(4) == true)
	assert(isPerfectSquare(5) == false)
	assert(isPerfectSquare(14) == false)
	assert(isPerfectSquare(15) == false)
	assert(isPerfectSquare(16) == true)
	assert(isPerfectSquare(24) == false)
	assert(isPerfectSquare(25) == true)
	assert(isPerfectSquare(26) == false)
	fmt.Println("Test All Pass.")
}
