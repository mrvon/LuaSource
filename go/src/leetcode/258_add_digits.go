package main

import "fmt"

func addDigits(num int) int {
	for {
		if num < 10 {
			return num
		} else {
			r := 0
			for num > 0 {
				r += num % 10
				num = num / 10
			}
			num = r
		}
	}
}

func main() {
	fmt.Println(addDigits(0))
}
