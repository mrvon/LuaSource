// comma inserts commas in a non-negative decimal integer string.
package main

import (
	"bytes"
	"fmt"
	"strings"
)

func comma(s string) string {
	n := len(s)
	if n <= 3 {
		return s
	}
	return comma(s[:n-3]) + "," + s[n-3:]
}

func non_recursive_comma(s string) string {
	if len(s) <= 3 {
		return s
	}

	var buf bytes.Buffer

	for l := len(s); l > 0; l = len(s) {
		var i = l % 3

		if buf.Len() > 0 {
			buf.WriteString(",")
		}

		if i == 0 {
			buf.WriteString(s[:3])
			s = s[3:]
		} else {
			buf.WriteString(s[:i])
			s = s[i:]
		}
	}

	return buf.String()
}

func main() {
	fmt.Println(comma("1"))
	fmt.Println(comma("12"))
	fmt.Println(comma("123"))
	fmt.Println(comma("1234"))
	fmt.Println(comma("12345"))
	fmt.Println(comma("123456"))
	fmt.Println(comma("1234567"))
	fmt.Println(comma("12345678"))
	fmt.Println(comma("123456789"))

	fmt.Println(non_recursive_comma("1"))
	fmt.Println(non_recursive_comma("12"))
	fmt.Println(non_recursive_comma("123"))
	fmt.Println(non_recursive_comma("1234"))
	fmt.Println(non_recursive_comma("12345"))
	fmt.Println(non_recursive_comma("123456"))
	fmt.Println(non_recursive_comma("1234567"))
	fmt.Println(non_recursive_comma("12345678"))
	fmt.Println(non_recursive_comma("123456789"))

	float_version("+1.2")
}
