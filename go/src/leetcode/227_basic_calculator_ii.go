// Solution using stack
// This program can accept 224 & 227
package main

import "fmt"

type Token struct {
	t   byte
	val int
}

type Stack struct {
	S []Token
}

func (S *Stack) len() int {
	return len(S.S)
}

func (S *Stack) push(t Token) {
	S.S = append(S.S, t)
}

func (S *Stack) pop() (t Token) {
	t = S.S[len(S.S)-1]
	S.S = S.S[:len(S.S)-1]
	return
}

func (S *Stack) peak() (t Token) {
	t = S.S[len(S.S)-1]
	return
}

func precedence(t byte) int {
	if t == '+' || t == '-' {
		return 1
	} else if t == '*' || t == '/' {
		return 2
	} else { // ( )
		return 0
	}
}

func is_low(t1 byte, t2 byte) bool {
	return precedence(t1) < precedence(t2)
}

func arithmetic(o Token, a Token, b Token) Token {
	if o.t == '+' {
		return Token{val: a.val + b.val}
	} else if o.t == '-' {
		return Token{val: a.val - b.val}
	} else if o.t == '*' {
		return Token{val: a.val * b.val}
	} else {
		if b.val == 0 {
			panic("can't divided by zero")
		}
		return Token{val: a.val / b.val}
	}
}

func calculate(s string) int {
	var os Stack // operator stack
	var is Stack // integer stack

	i := 0

	for i < len(s) {
		c := s[i]

		if c == ' ' {
			// skip whitespace
			i++
			continue
		} else if c >= '0' && c <= '9' {
			// integer
			num := 0
			for i < len(s) && s[i] >= '0' && s[i] <= '9' {
				num *= 10
				num += int(s[i] - '0')
				i++
			}
			is.push(Token{val: num})
		} else if c == '(' {
			i++
			os.push(Token{t: c})
		} else if c == ')' {
			i++
			for {
				o := os.pop()
				if o.t == '(' {
					break
				}

				b := is.pop()
				a := is.pop()
				is.push(arithmetic(o, a, b))

			}
		} else {
			// arithmetic operator
			i++
			for os.len() > 0 && !is_low(os.peak().t, c) {
				o := os.pop()
				b := is.pop()
				a := is.pop()
				is.push(arithmetic(o, a, b))
			}
			os.push(Token{t: c})
		}
	}

	for os.len() > 0 {
		o := os.pop()
		b := is.pop()
		a := is.pop()
		is.push(arithmetic(o, a, b))
	}

	if is.len() == 1 {
		return is.pop().val
	} else {
		panic("invalid expression")
	}
}

func assert(expect int, result int) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %d, Get %d", expect, result))
	}
}

func main() {
	assert(2, calculate("1 + 1"))
	assert(6, calculate("1 + 2 + 3"))
	assert(3, calculate("2-1 + 2 "))
	assert(2, calculate("(1 + 1)"))
	assert(0, calculate("(1 + 1) - 2"))
	assert(1, calculate("1"))
	assert(1, calculate("(1)"))
	assert(23, calculate("(1+(4+5+2)-3)+(6+8)"))
	assert(7, calculate("3+2*2"))
	assert(1, calculate("3/2 "))
	assert(5, calculate("3+5 / 2"))
}
