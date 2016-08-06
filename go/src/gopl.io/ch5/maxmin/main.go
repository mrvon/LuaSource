package main

import "fmt"

func max(max int, vals ...int) int {
	for _, val := range vals {
		if val > max {
			max = val
		}
	}
	return max
}

func min(min int, vals ...int) int {
	for _, val := range vals {
		if val < min {
			min = val
		}
	}
	return min
}

func join(sep string, strs ...string) string {
	out := ""
	for _, val := range strs {
		if len(out) > 0 {
			out += sep
		}
		out += val
	}
	return out
}

func main() {
	// fmt.Println(max()) -- compiler error!
	fmt.Println(max(1))
	fmt.Println(max(1, 2))
	fmt.Println(max(1, 2, 1000))
	fmt.Println(max(9999, 1, 2, 1000))

	fmt.Println(min(9999, 1, 2, 1000))

	fmt.Println(join(", ", "Hello", "World", "世界"))
}
