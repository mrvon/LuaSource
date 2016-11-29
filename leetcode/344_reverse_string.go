package main

import "fmt"

func reserveString(s string) string {
	var n []byte
	b := []byte(s)
	for i := len(b) - 1; i >= 0; i-- {
		n = append(n, b[i])
	}
	return string(n)
}

func main() {
	fmt.Println(reserveString("hello"))
	fmt.Println(reserveString("fuck"))
	fmt.Println(reserveString("ada"))
}
