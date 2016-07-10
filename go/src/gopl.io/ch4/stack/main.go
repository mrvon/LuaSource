package main

import (
	"fmt"
)

func main() {
	stack := []string{}              // Empty stack
	stack = append(stack, "Hello")   // Push
	stack = append(stack, "world")   // Push
	stack = append(stack, "End")     // Push
	fmt.Println(stack)               // The stack
	fmt.Println(stack[len(stack)-1]) // Top
	stack = stack[:len(stack)-1]     // Pop
	fmt.Println(stack)               // The stack
	fmt.Println(stack[len(stack)-1]) // Top
}
