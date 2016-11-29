package main

import "fmt"

func counter(num int) int {
	c := 0
	for num > 0 {
		num = num & (num - 1)
		c++
	}
	return c
}

func countBits(num int) []int {
	var r []int
	for i := 0; i <= num; i++ {
		r = append(r, counter(i))
	}
	return r
}

func main() {
	fmt.Println(countBits(5))
}
