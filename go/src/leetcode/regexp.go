package main

import "fmt"

func __re2post(re string, i int, postfix []byte) ([]byte, int) {
	for i < len(re) {
		c := re[i]

		if c == '(' {
			postfix, i = __re2post(re, i+1, postfix)
		} else if c == ')' {
			return postfix, i
		} else {
			postfix = append(postfix, c)
		}
		i++
	}

	return postfix, i
}

func re2post(re string) string {
	postfix, _ := __re2post(re, 0, []byte{})
	return string(postfix)
}

func main() {
	fmt.Println(re2post("a(bb)+a"))       // abb$+$a$
	fmt.Println(re2post("(abb)+a"))       // ab$b$+a$
	fmt.Println(re2post("a(bb)+a"))       // abb$+$a$
	fmt.Println(re2post("a(bb|c)+a"))     // abb$c|+$a$
	fmt.Println(re2post("a(bb|c*)+a"))    // abb$c*|+$a$
	fmt.Println(re2post("a(bb(ccc)*)+a")) // abbcc$c$*$$+$a$
}
