package main

import "fmt"

const (
	NUMBER   = 0
	PLUS     = 1
	MINUS    = 2
	TIMES    = 3
	DIVISION = 4
	LPAREN   = 5
	RPAREN   = 6
)

type Token struct {
	t   int
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

func precedence(t int) int {
	if t == PLUS || t == MINUS {
		return 1
	} else if t == TIMES || t == DIVISION {
		return 2
	} else {
		return 0
	}
}

func is_low(t1 int, t2 int) bool {
	return precedence(t1) < precedence(t2)
}

func convert(infix_list []Token) []Token {
	var postfix_list []Token
	var s Stack // operator stack

	for i := 0; i < len(infix_list); i++ {
		t := infix_list[i]
		if t.t == NUMBER {
			postfix_list = append(postfix_list, t)
		} else if t.t == LPAREN {
			s.push(t)
		} else if t.t == RPAREN {
			for s.peak().t != LPAREN {
				postfix_list = append(postfix_list, s.peak())
				s.pop()
			}
			s.pop()
		} else {
			// operator
			for s.len() > 0 && !is_low(s.peak().t, t.t) {
				postfix_list = append(postfix_list, s.pop())
			}
			s.push(t)
		}
	}

	for s.len() > 0 {
		postfix_list = append(postfix_list, s.pop())
	}

	return postfix_list
}

func build_expression(s string) []Token {
	var token_list []Token
	for i := 0; i < len(s); i++ {
		var token Token
		if s[i] >= '0' && s[i] <= '9' {
			token.t = NUMBER
			token.val = int(s[i] - '0')
		} else {
			if s[i] == '+' {
				token.t = PLUS
			} else if s[i] == '-' {
				token.t = MINUS
			} else if s[i] == '*' {
				token.t = TIMES
			} else if s[i] == '/' {
				token.t = DIVISION
			} else if s[i] == '(' {
				token.t = LPAREN
			} else if s[i] == ')' {
				token.t = RPAREN
			} else {
				panic("invalid input.")
			}
		}
		token_list = append(token_list, token)
	}
	return token_list
}

func print_expression(token_list []Token) {
	for i := 0; i < len(token_list); i++ {
		t := token_list[i]
		if t.t == NUMBER {
			fmt.Printf("%d ", t.val)
		} else if t.t == PLUS {
			fmt.Print(" + ")
		} else if t.t == MINUS {
			fmt.Print(" - ")
		} else if t.t == TIMES {
			fmt.Print(" * ")
		} else if t.t == DIVISION {
			fmt.Print(" / ")
		} else if t.t == LPAREN {
			fmt.Print(" ( ")
		} else if t.t == RPAREN {
			fmt.Print(" ) ")
		}
	}
	fmt.Println("")
}

func main() {
	print_expression(convert(build_expression("(1+2)*3")))
	print_expression(convert(build_expression("3*((1+2)*(1-2))")))
	print_expression(convert(build_expression("0/1")))
}
