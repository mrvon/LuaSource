package main

import (
	"fmt"
)

// reverse reverses a slice of ints in place.
func reverse(s []int) {
	for i, j := 0, len(s)-1; i < j; i, j = i+1, j-1 {
		s[i], s[j] = s[j], s[i]
	}
}

func reverse_using_arr_ptr(p *[6]int) {
	for i, j := 0, len(*p)-1; i < j; i, j = i+1, j-1 {
		(*p)[i], (*p)[j] = (*p)[j], (*p)[i]
	}
}

func main() {
	a := [...]int{0, 1, 2, 3, 4, 5}
	b := [...]int{0, 1, 2, 3, 4, 5}

	// array is comparable
	fmt.Println(a == b)

	fmt.Println(a)
	reverse(a[:])
	fmt.Println(a)

	s1 := []int{0, 1, 2, 3, 4, 5}
	// Rotate s left by two positions.
	reverse(s1[:2])
	reverse(s1[2:])
	reverse(s1)
	fmt.Println(s1)

	// Rotate s right by two positions.
	s2 := []int{0, 1, 2, 3, 4, 5}
	reverse(s2)
	reverse(s2[:2])
	reverse(s2[2:])
	fmt.Println(s2)

	// slice is not comparable (slice can only compare to nil)
	// fmt.Println(s1 == s2)

	fmt.Printf("%T %T %T\n", a, s1, s2)

	c := [...]int{0, 1, 2, 3, 4, 5}

	fmt.Println(c)
	reverse_using_arr_ptr(&c)
	fmt.Println(c)
}
