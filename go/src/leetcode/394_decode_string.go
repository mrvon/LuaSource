package main

import (
	"fmt"
	"strconv"
)

func is_digit(c byte) bool {
	return c >= '0' && c <= '9'
}

type State struct {
	input []byte
	index int
}

func (s *State) curr() byte {
	return s.input[s.index]
}

func (s *State) curr_k() int {
	var num []byte
	num = append(num, s.curr())
	for s.next() {
		if !is_digit(s.curr()) {
			s.undo()
			break
		}
		num = append(num, s.curr())
	}

	i, err := strconv.Atoi(string(num))

	if err != nil {
		return 0
	} else {
		return i
	}
}

func (s *State) undo() {
	s.index--
}

func (s *State) next() bool {
	s.index++
	if s.index >= len(s.input) {
		return false
	} else {
		return true
	}
}

func decode_l(s *State) []byte {
	b := []byte{}
	b = append(b, s.curr())

	for {
		if !s.next() {
			break
		}

		if is_digit(s.curr()) {
			s.undo()
			break
		}

		b = append(b, s.curr())
	}
	return b
}

func decode_k(s *State) []byte {
	k := s.curr_k()
	fmt.Println(k)
	b := []byte{}
	s.next() // '['
	for {
		if !s.next() {
			break
		}
		c := s.curr()
		if c == ']' {
			// End
			o := b
			b = []byte{}
			for i := 0; i < k; i++ {
				b = append(b, o...)
			}
			return b
		} else if is_digit(c) {
			// Sub
			sb := decode_k(s)
			for i := 0; i < len(sb); i++ {
				b = append(b, sb[i])
			}
		} else {
			b = append(b, c)
		}
	}
	return b
}

func decodeString(s string) string {
	state := &State{
		input: []byte(s),
		index: -1,
	}

	var r []byte

	for state.next() {
		if is_digit(state.curr()) {
			// k string
			r = append(r, decode_k(state)...)
		} else {
			// literal string
			r = append(r, decode_l(state)...)
		}
	}

	return string(r)
}

func main() {
	i, err := strconv.Atoi("-42")
	fmt.Println(i, err)
	fmt.Println(decodeString(""))
	fmt.Println(decodeString("3[a]"))
	fmt.Println(decodeString("3[a2[c]]"))
	fmt.Println(decodeString("3[a]2[bc]"))
	fmt.Println(decodeString("2[abc]3[cd]ef"))
	fmt.Println(decodeString("dennis3[a]"))
	fmt.Println(decodeString("10[a]"))
	fmt.Println(decodeString("100[leetcode]"))
}
