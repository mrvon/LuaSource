package main

type Stack struct {
	S []byte
}

func (S *Stack) push(c byte) {
	S.S = append(S.S, c)
}

func (S *Stack) pop() byte {
	c := S.S[len(S.S)-1]
	S.S = S.S[:len(S.S)-1]
	return c
}

func (S *Stack) isempty() bool {
	return len(S.S) == 0
}

func (S *Stack) peek() byte {
	return S.S[len(S.S)-1]
}

func isMatch(l byte, r byte) bool {
	if l == '(' {
		return r == ')'
	} else if l == '{' {
		return r == '}'
	} else if l == '[' {
		return r == ']'
	} else {
		return false
	}
}

func isValid(s string) bool {
	var stk Stack
	for i := 0; i < len(s); i++ {
		if stk.isempty() {
			stk.push(s[i])
		} else {
			if isMatch(stk.peek(), s[i]) {
				stk.pop()
			} else {
				stk.push(s[i])
			}
		}
	}
	if stk.isempty() {
		return true
	} else {
		return false
	}
}

func assert(b bool) {
	if !b {
		panic("assert failed")
	}
}

func main() {
	assert(isValid("{}") == true)
	assert(isValid("{}[]") == true)
	assert(isValid("(){}[]") == true)
	assert(isValid("{]") == false)
	assert(isValid("({])") == false)
	assert(isValid("({()})") == true)
}
