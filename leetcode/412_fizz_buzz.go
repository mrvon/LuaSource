package main

import "fmt"

func fizzBuzz(n int) []string {
	var r []string
	for i := 1; i <= n; i++ {
		d3 := (i%3 == 0)
		d5 := (i%5 == 0)

		if d3 && d5 {
			r = append(r, "FizzBuzz")
		} else if d3 {
			r = append(r, "Fizz")
		} else if d5 {
			r = append(r, "Buzz")
		} else {
			r = append(r, fmt.Sprintf("%d", i))
		}
	}
	return r
}

func main() {
	r := fizzBuzz(15)
	for i := 0; i < len(r); i++ {
		fmt.Println(r[i])
	}
}
