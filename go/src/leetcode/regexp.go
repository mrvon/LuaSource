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
			atom++

			// sub regexp
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

func assert(expect string, result string) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %s, Get %s", expect, result))
	}
}

func main() {
	assert(re2post("abba"), "ab$b$a$")
	assert(re2post("abba(ab)"), "ab$b$a$ab$$")
	assert(re2post("a(bb)+a"), "abb$+$a$")
	assert(re2post("(abb)+a"), "ab$b$+a$")
	assert(re2post("a(bb)+a"), "abb$+$a$")
	// assert(re2post("a(bb|c)+a"), "abb$c|+$a$")
	// assert(re2post("a(bb|c*)+a"), "abb$c*|+$a$")
	assert(re2post("a(bb(ccc)*)+a"), "abb$cc$c$*$+$a$")
}
