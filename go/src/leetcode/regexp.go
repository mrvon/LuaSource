package main

import "fmt"

func __re2post(re string, i int, postfix []byte) ([]byte, int) {
	atom := 0  // for concatenation
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

			if c == '+' || c == '*' || c == '?' {
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

func assert_i(result int, expect int) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %d, Get %d", expect, result))
	}
}

func assert_b(result bool) {
	if !result {
		panic(fmt.Sprintf("Assert failed!"))
	}
}

const (
	MATCH = 256
	SPLIT = 257
)

// Basic NFA element
type State struct {
	c     int // character
	out_1 *State
	out_2 *State
}

var MatchState = &State{
	c: MATCH,
}

// A Partially built NFA without the matching state filled in.
type Fragment struct {
	start   *State
	outlist []**State
}

type Stack struct {
	S []Fragment
}

func (S *Stack) len() int {
	return len(S.S)
}

func (S *Stack) push(t Fragment) {
	S.S = append(S.S, t)
}

func (S *Stack) pop() (t Fragment) {
	t = S.S[len(S.S)-1]
	S.S = S.S[:len(S.S)-1]
	return
}

func (S *Stack) peak() (t Fragment) {
	t = S.S[len(S.S)-1]
	return
}

func post2nfa(postfix string) *State {
	if len(postfix) == 0 {
		return nil
	}

	var s Stack

	for i := 0; i < len(postfix); i++ {
		c := postfix[i]

		if c == '$' {
			// concatenation
			e2 := s.pop()
			e1 := s.pop()
			for i := 0; i < len(e1.outlist); i++ {
				(*e1.outlist[i]) = e2.start
			}
			f := Fragment{
				start: e1.start,
			}
			f.outlist = append(f.outlist, e2.outlist...)
			s.push(f)
		} else if c == '|' {
			// alternation
			e2 := s.pop()
			e1 := s.pop()
			state := &State{
				c:     SPLIT,
				out_1: e1.start,
				out_2: e2.start,
			}
			f := Fragment{
				start: state,
			}
			f.outlist = append(f.outlist, e1.outlist...)
			f.outlist = append(f.outlist, e2.outlist...)
			s.push(f)
		} else if c == '?' {
			// zero or one
			e := s.pop()
			state := &State{
				c:     SPLIT,
				out_1: e.start,
			}
			f := Fragment{
				start:   state,
				outlist: []**State{&state.out_2},
			}
			f.outlist = append(f.outlist, e.outlist...)
			s.push(f)
		} else if c == '*' {
			// zero or more
			e := s.pop()
			state := &State{
				c:     SPLIT,
				out_1: e.start,
			}
			for i := 0; i < len(e.outlist); i++ {
				(*e.outlist[i]) = state
			}
			s.push(Fragment{
				start:   state,
				outlist: []**State{&state.out_2},
			})
		} else if c == '+' {
			// one or more
			e := s.pop()
			state := &State{
				c:     SPLIT,
				out_1: e.start,
			}
			for i := 0; i < len(e.outlist); i++ {
				(*e.outlist[i]) = state
			}
			s.push(Fragment{
				start:   e.start,
				outlist: []**State{&state.out_2},
			})
		} else {
			state := &State{
				c: int(c),
			}
			s.push(Fragment{
				start:   state,
				outlist: []**State{&state.out_1},
			})
		}
	}

	e := s.pop()
	if s.len() != 0 {
		// invalid regexp
		return nil
	}

	for i := 0; i < len(e.outlist); i++ {
		(*e.outlist[i]) = MatchState
	}

	return e.start
}

func is_match(state_list map[*State]bool) bool {
	for state := range state_list {
		if state == MatchState {
			return true
		}
	}
	return false
}

func match(state *State, s string) bool {
	if state == nil {
		return false
	}

	state_list := make(map[*State]bool)
	follow_unlabeled_arrow(state_list, state)

	for i := 0; i < len(s); i++ {
		new_list := make(map[*State]bool)
		c := int(s[i])

		for state := range state_list {
			if state.c == c {
				follow_unlabeled_arrow(new_list, state.out_1)
			}
		}

		state_list = new_list
	}

	return is_match(state_list)
}

func follow_unlabeled_arrow(state_list map[*State]bool, state *State) {
	if state == nil {
		return
	}

	if state.c == SPLIT {
		follow_unlabeled_arrow(state_list, state.out_1)
		follow_unlabeled_arrow(state_list, state.out_2)
	} else {
		state_list[state] = true
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

	assert(re2post("."), ".")
	assert(re2post(".+"), ".+")
	assert(re2post(".*"), ".*")
	assert(re2post("he.*llo"), "he$.*$l$l$o$")

	assert(re2post(".?"), ".?")
	assert(re2post("a?"), "a?")
	assert(re2post("ab?"), "ab?$")
	assert(re2post("a+b?"), "a+b?$")
	assert(re2post("(a+b?)*"), "a+b?$*")
}

func test_post2nfa_1() {
	s := post2nfa(re2post("ab"))
	assert_i(s.c, 'a')
	assert_i(s.out_1.c, 'b')
	assert_i(s.out_1.out_1.c, MATCH)
	assert_b(s.out_2 == nil)
}

func test_post2nfa_2() {
	s := post2nfa(re2post("a|b"))
	assert_i(s.c, SPLIT)
	assert_i(s.out_1.c, 'a')
	assert_i(s.out_2.c, 'b')
	assert_i(s.out_1.out_1.c, MATCH)
	assert_i(s.out_2.out_1.c, MATCH)
}

func test_post2nfa_3() {
	s := post2nfa(re2post("(ab)*"))
	assert_i(s.c, SPLIT)
	assert_i(s.out_1.c, 'a')
	assert_i(s.out_2.c, MATCH)
	assert_i(s.out_1.out_1.c, 'b')
	assert_i(s.out_1.out_1.out_1.c, SPLIT)
	assert_i(s.out_1.out_1.out_1.out_1.c, 'a')
	assert_i(s.out_1.out_1.out_1.out_1.out_1.c, 'b')

}

func test_post2nfa_4() {
	s := post2nfa(re2post("(ab)+"))
	assert_i(s.c, 'a')
	assert_i(s.out_1.c, 'b')
	assert_i(s.out_1.out_1.c, SPLIT)
	assert_i(s.out_1.out_1.out_1.c, 'a')
	assert_i(s.out_1.out_1.out_2.c, MATCH)
	assert_i(s.out_1.out_1.out_1.out_1.c, 'b')
	assert_i(s.out_1.out_1.out_1.out_1.out_1.c, SPLIT)
}

func test_post2nfa_5() {
	s := post2nfa(re2post("a?"))
	assert_i(s.c, SPLIT)
	assert_i(s.out_1.c, 'a')
	assert_i(s.out_2.c, MATCH)
	assert_b(s.out_1.out_1.c == MATCH)
}

func test_match() {
	assert_b(match(post2nfa(re2post("a")), "a") == true)
	assert_b(match(post2nfa(re2post("a")), "b") == false)
	assert_b(match(post2nfa(re2post("a?")), "") == true)
	assert_b(match(post2nfa(re2post("a?")), "a") == true)
	assert_b(match(post2nfa(re2post("a*")), "") == true)
	assert_b(match(post2nfa(re2post("a*")), "a") == true)
	assert_b(match(post2nfa(re2post("a*")), "aa") == true)
	assert_b(match(post2nfa(re2post("a*")), "aaa") == true)
	assert_b(match(post2nfa(re2post("ba*")), "aaa") == false)
	assert_b(match(post2nfa(re2post("ba*")), "baaa") == true)
	assert_b(match(post2nfa(re2post("abba")), "abbc") == false)
	assert_b(match(post2nfa(re2post("abba")), "abba") == true)
	assert_b(match(post2nfa(re2post("abba(ab)")), "abbab") == false)
	assert_b(match(post2nfa(re2post("abba(ab)")), "abbaab") == true)
	assert_b(match(post2nfa(re2post("a(bb)+a")), "abbbbb") == false)
	assert_b(match(post2nfa(re2post("a(bb)+a")), "abbbba") == true)
	assert_b(match(post2nfa(re2post("(abb)+a")), "abbbbba") == false)
	assert_b(match(post2nfa(re2post("(abb)+a")), "abba") == true)
	assert_b(match(post2nfa(re2post("(abb)+a")), "abbabba") == true)
	assert_b(match(post2nfa(re2post("a+")), "") == false)
	assert_b(match(post2nfa(re2post("a+")), "a") == true)
	assert_b(match(post2nfa(re2post("a+")), "aa") == true)
	assert_b(match(post2nfa(re2post("a+")), "aaa") == true)
	assert_b(match(post2nfa(re2post("ba+")), "aaa") == false)
	assert_b(match(post2nfa(re2post("ba+")), "baaa") == true)
	assert_b(match(post2nfa(re2post("(a)+")), "") == false)
	assert_b(match(post2nfa(re2post("(aa)+")), "") == false)
	assert_b(match(post2nfa(re2post("(aa)+")), "aa") == true)
	assert_b(match(post2nfa(re2post("(aa)+")), "aaa") == false)
	assert_b(match(post2nfa(re2post("(aa)+")), "aaaa") == true)
	assert_b(match(post2nfa(re2post("(aa)+")), "aa") == true)
	assert_b(match(post2nfa(re2post("(abb)+a")), "abbabba") == true)
	assert_b(match(post2nfa(re2post("a(bb(ccc)*)+a")), "abba") == true)
}

func main() {
	test_re2post()
	test_post2nfa_1()
	test_post2nfa_2()
	test_post2nfa_3()
	test_post2nfa_4()
	test_post2nfa_5()
	test_match()
}
