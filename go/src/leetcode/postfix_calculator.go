package main

import "fmt"

const (
	NUMBER   = 0
	PLUS     = 1
	MINUS    = 2
	TIMES    = 3
	DIVISION = 4
)

type Token struct {
	t   int
	val float64
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

func eval(token_list []Token) float64 {
	var s Stack
	for i := 0; i < len(token_list); i++ {
		token := token_list[i]
		if token.t == NUMBER {
			s.push(token)
		} else {
			if s.len() < 2 {
				panic("invalid expression")
			}
			op_b := s.pop()
			op_a := s.pop()
			if token.t == PLUS {
				n := Token{
					t:   NUMBER,
					val: op_a.val + op_b.val,
				}
				s.push(n)
			} else if token.t == MINUS {
				n := Token{
					t:   NUMBER,
					val: op_a.val - op_b.val,
				}
				s.push(n)
			} else if token.t == TIMES {
				n := Token{
					t:   NUMBER,
					val: op_a.val * op_b.val,
				}
				s.push(n)
			} else {
				if op_b.val == 0 {
					panic("can't divided by zero.")
				}
				n := Token{
					t:   NUMBER,
					val: op_a.val / op_b.val,
				}
				s.push(n)
			}
		}
	}

	if s.len() != 1 {
		panic("invalid expression")
	} else {
		return s.pop().val
	}
}

func build_expression(s string) []Token {
	var token_list []Token
	for i := 0; i < len(s); i++ {
		var token Token
		if s[i] >= '0' && s[i] <= '9' {
			token.t = NUMBER
			token.val = float64(s[i] - '0')
		} else {
			if s[i] == '+' {
				token.t = PLUS
			} else if s[i] == '-' {
				token.t = MINUS
			} else if s[i] == '*' {
				token.t = TIMES
			} else {
				token.t = DIVISION
			}
		}
		token_list = append(token_list, token)
	}
	return token_list
}

func main() {
	fmt.Println(eval(build_expression("312+*")))
	fmt.Println(eval(build_expression("312+12-**")))
	fmt.Println(eval(build_expression("01/")))
	// fmt.Println(eval(build_expression("10/")))
}
