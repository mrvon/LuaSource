package main

import "fmt"

const (
	DIR  = 1
	FILE = 2
)

type Token struct {
	id     int
	level  int
	length int
}

type State struct {
	input     []byte
	index     int
	token     Token
	undo_flag bool
}

func (s *State) next() bool {
	if s.undo_flag {
		s.undo_flag = false
		return true
	}

	s.index++
	if s.index >= len(s.input) {
		return false
	}

	level := 0
	if s.input[s.index] == '\t' {
		for s.input[s.index] == '\t' {
			level++
			s.index++
		}
	}
	s.token.level = level

	length := 0
	s.token.id = DIR
	for s.input[s.index] != '\n' {
		if s.input[s.index] == '.' {
			s.token.id = FILE
		}
		length++
		s.index++
	}
	s.token.length = length
	return true
}

func (s *State) undo() {
	if s.undo_flag {
		panic("can't undo two time consecutively!")
	}
	s.undo_flag = true
}

func __longest(s *State, level int) int {
	len := s.token.length
	max := 0

	for s.next() {
		if s.token.id == DIR {
			// Is my child directory
			if s.token.level > level {
				l := __longest(s, s.token.level)
				if l > 0 {
					l += 1 // for /
					// Must be found a FILE
					if len+l > max {
						max = len + l
					}
				}
			} else {
				s.undo()
				break
			}
		} else {
			// Is my child file
			if s.token.level > level {
				// FILE
				l := 1 // for /
				l += s.token.length
				if len+l > max {
					max = len + l
				}
			} else {
				s.undo()
				break
			}
		}
	}

	return max
}

func lengthLongestPath(input string) int {
	if len(input) == 0 {
		return 0
	}

	s := &State{
		input:     append([]byte(input), '\n'),
		index:     -1,
		undo_flag: false,
	}

	max := 0
	for s.next() {
		l := 0
		if s.token.id == DIR {
			// ROOT DIR
			l = __longest(s, s.token.level)
		} else {
			// ROOT FILE
			l = s.token.length
		}
		if l > max {
			max = l
		}
	}
	return max
}

func assert(expect int, result int) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %d, Get %d", expect, result))
	}
}

func main() {
	assert(0, lengthLongestPath("a"))
	assert(0, lengthLongestPath("a\n\tb\n\t\tc"))
	assert(5, lengthLongestPath("a.txt"))
	assert(12, lengthLongestPath("dir\n    file.txt"))
	assert(16, lengthLongestPath("dir\n        file.txt"))
	assert(9, lengthLongestPath("a\n\tb.txt\na2\n\tb2.txt"))
	assert(20, lengthLongestPath("dir\n\tsubdir1\n\tsubdir2\n\t\tfile.ext"))
	assert(32, lengthLongestPath("dir\n\tsubdir1\n\t\tfile1.ext\n\t\tsubsubdir1\n\tsubdir2\n\t\tsubsubdir2\n\t\t\tfile2.ext"))
	assert(133, lengthLongestPath("skd\n\tskdjfl\n\t\tsladkfjlj\n\t\tlskjdflkjsdlfjsldjfljslkjlkjslkjslfjlskjgldfjlkfdjbljdbkjdlkjkasljfklasjdfkljaklwejrkljewkljfslkjflksjfvsafjlgjfljgklsdf.a"))
}
