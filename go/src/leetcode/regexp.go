package main

import "fmt"

func __re2post(re string, i int, postfix []byte) ([]byte, int) {
	atom := 0  // for concatation
	alter := 0 // for alternation

	for i < len(re) {
		c := re[i]

		if c == '(' {
			// into sub regexp

			if atom >= 2 {
				atom--
				postfix = append(postfix, '$')
			}
			atom++

			for i := 0; i < alter; i++ {
				postfix = append(postfix, '|')
			}

			postfix, i = __re2post(re, i+1, postfix)
		} else if c == ')' {
			// exit sub regexp

			if atom >= 2 {
				atom--
				postfix = append(postfix, '$')
			}

			for i := 0; i < alter; i++ {
				postfix = append(postfix, '|')
			}

			return postfix, i
		} else {
			// operator or literal

			if c == '+' || c == '*' {
				postfix = append(postfix, c)
			} else if c == '|' {
				if atom >= 2 {
					postfix = append(postfix, '$')
				}
				atom = 0 // reset
				alter++
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

	for i := 0; i < alter; i++ {
		postfix = append(postfix, '|')
	}

	return postfix, i
}

func re2post(re string) string {
	postfix, _ := __re2post(re, 0, []byte{})
	return string(postfix)
}

func assert(result string, expect string) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %s, Get %s", expect, result))
	}
}

func test_re2post() {
	assert(re2post("abba"), "ab$b$a$")
	assert(re2post("abba(ab)"), "ab$b$a$ab$$")
	assert(re2post("a(bb)+a"), "abb$+$a$")
	assert(re2post("(abb)+a"), "ab$b$+a$")
	assert(re2post("a(bb)+a"), "abb$+$a$")
	assert(re2post("a(bb(ccc)*)+a"), "abb$cc$c$*$+$a$")

	assert(re2post("a*"), "a*")
	assert(re2post("ab*"), "ab*$")
	assert(re2post("a|b"), "ab|")
	assert(re2post("ab|b"), "ab$b|")
	assert(re2post("abc|b"), "ab$c$b|")
	assert(re2post("abc|bcd"), "ab$c$bc$d$|")

	assert(re2post("a(bb|c)+a"), "abb$c|+$a$")
	assert(re2post("a(bb|c*)+a"), "abb$c*|+$a$")

	assert(re2post("a(b*)c"), "ab*$c$")
	assert(re2post("a*(b*)c+"), "a*b*$c+$")
	assert(re2post("a*(b*)(c+)"), "a*b*$c+$")
	assert(re2post("(a*)(b*)+(c+)"), "a*b*+$c+$")
	assert(re2post("a*b*|c+"), "a*b*$c+|")
}

func main() {
	test_re2post()
}
