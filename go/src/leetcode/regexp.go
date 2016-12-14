package main

import "fmt"

func __re2post(re string, i int, postfix []byte) ([]byte, int) {
	atom := 0

	for i < len(re) {
		c := re[i]

		if c == '(' {
			if atom >= 2 {
				atom--
				postfix = append(postfix, '$')
			}
			postfix, i = __re2post(re, i+1, postfix)
		} else if c == ')' {
			if atom >= 2 {
				atom--
				postfix = append(postfix, '$')
			}
			return postfix, i
		} else {
			if c == '+' || c == '*' {
				postfix = append(postfix, c)
			} else {
				if atom >= 2 {
					atom--
					postfix = append(postfix, '$')
				}
				atom++

				// literal
				postfix = append(postfix, c)
			}
		}
		i++
	}

	// regexp end
	if atom >= 2 {
		atom--
		postfix = append(postfix, '$')
	}

	return postfix, i
}

func re2post(re string) string {
	postfix, _ := __re2post(re, 0, []byte{})
	return string(postfix)
}

func main() {
	fmt.Println(re2post("abba"))     // ab$b$a$
	fmt.Println(re2post("abba(ab)")) // ab$b$a$ab$$
	fmt.Println(re2post("a(bb)+a"))  // abb$+$a$
	fmt.Println(re2post("(abb)+a"))  // ab$b$+a$
	fmt.Println(re2post("a(bb)+a"))  // abb$+$a$
	// fmt.Println(re2post("a(bb|c)+a"))     // abb$c|+$a$
	// fmt.Println(re2post("a(bb|c*)+a"))    // abb$c*|+$a$
	// fmt.Println(re2post("a(bb(ccc)*)+a")) // abbcc$c$*$$+$a$
}
