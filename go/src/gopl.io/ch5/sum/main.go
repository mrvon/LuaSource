package main

import (
	"fmt"
	"os"
)

func sum(vals ...int) int {
	total := 0
	for _, val := range vals {
		total += val
	}
	return total
}

func main() {
	fmt.Println(sum())
	fmt.Println(sum(3))
	fmt.Println(sum(1, 2, 3, 4))

	values := []int{1, 2, 3, 4}
	fmt.Println(sum(values...))
	fmt.Println(sum(values[:1]...))
	fmt.Println(sum(values[1:]...))

	// Although the ...int parameter behaves like a slice with the function
	// body, the type of a variadic function is distinct from the type of a
	// function with an ordinary slice parameter

	var f func(...int)
	var g func([]int)

	fmt.Printf("%T\n", f)
	fmt.Printf("%T\n", g)
}
