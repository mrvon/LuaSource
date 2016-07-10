// Nonempty is an example of an in-place slice program.
package main

import (
	"fmt"
)

// nonempty returns a slice holding only the non-empty strings.
// The underlying array is modified during the call
func nonempty(strings []string) []string {
	i := 0
	for _, s := range strings {
		if s != "" {
			strings[i] = s
			i++
		}
	}
	return strings[:i]
}

func nonempty2(strings []string) []string {
	out := strings[:0] // zero-lenght slice of original
	for _, s := range strings {
		if s != "" {
			out = append(out, s)
		}
	}
	return out
}

// This is wrong, your must becareful when you modified the element of the array
// which you are just traversing.
func wrongcase(strings []string) []string {
	out := strings[:0]
	for i := len(strings) - 1; i >= 0; i-- {
		s := strings[i]
		if s != "" {
			out = append(out, s)
		}
	}
	return out
}

func main() {
	data := []string{"one", "", "three"}
	// fmt.Printf("%q\n", nonempty(data))
	// fmt.Printf("%q\n", nonempty2(data))

	fmt.Printf("%q\n", data)
	fmt.Printf("%q\n", wrongcase(data))
	fmt.Printf("%q\n", data)
}
