package main

import "fmt"

func factor(m int) []int {
	var factor_list []int

	factor_list = append(factor_list, 1)

	for i := 2; i <= m/2; i++ {
		if m%i == 0 {
			factor_list = append(factor_list, i)
		}
	}

	return factor_list
}

func repeatedSubstringPattern(str string) bool {
	b := []byte(str)

	if len(b) <= 1 {
		return false
	}

	factor_list := factor(len(b))

	for k := 0; k < len(factor_list); k++ {
		// substring length is l
		l := factor_list[k]

		is_same := true

		// check substring
		for i := 0; i < l; i++ {
			n := i + l
			for n < len(b) {
				if b[i] != b[n] {
					is_same = false
					break
				}
				n += l
			}
			if !is_same {
				break
			}
		}

		// found it.
		if is_same {
			return true
		}
	}

	return false
}

func assert(expect bool, result bool) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %b, Get %b", expect, result))
	}
}

func main() {
	assert(false, repeatedSubstringPattern("a"))
	assert(true, repeatedSubstringPattern("aa"))
	assert(false, repeatedSubstringPattern("ab"))
	assert(false, repeatedSubstringPattern("aba"))
	assert(false, repeatedSubstringPattern("aab"))
	assert(true, repeatedSubstringPattern("aaa"))
	assert(false, repeatedSubstringPattern("abababc"))
	assert(true, repeatedSubstringPattern("ababab"))
	assert(false, repeatedSubstringPattern("abcabcab"))
	assert(true, repeatedSubstringPattern("abcabcabc"))
}
