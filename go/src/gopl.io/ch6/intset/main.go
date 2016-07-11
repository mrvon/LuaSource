// An InSet is a set of small non-negative integers
// Its zero value represents the empty set.
package main

import (
	"bytes"
	"fmt"
)

type IntSet struct {
	words []uint64
}

// Has reports whether the set contains the non-negative value x.
func (s *IntSet) Has(x int) bool {
	word, bit := x/64, uint(x%64)
	return word < len(s.words) && s.words[word]&(1<<bit) != 0
}

// Add adds the non-negative value x to the set.
func (s *IntSet) Add(x int) {
	word, bit := x/64, uint(x%64)
	for word >= len(s.words) {
		s.words = append(s.words, 0)
	}
	s.words[word] |= 1 << bit
}

// UnionWith sets s to the union of s and t.
func (s *IntSet) UnionWith(t *IntSet) {
	for i, tword := range t.words {
		if i < len(s.words) {
			s.words[i] |= tword
		} else {
			s.words = append(s.words, tword)
		}
	}
}

func (s *IntSet) String() string {
	var buf bytes.Buffer
	buf.WriteByte('{')
	for i, word := range s.words {
		if word == 0 {
			continue
		}
		for j := 0; j < 64; j++ {
			if word&(1<<uint(j)) != 0 {
				if buf.Len() > len("{") {
					buf.WriteByte(' ')
				}
				fmt.Fprintf(&buf, "%d", 64*i+j)
			}
		}
	}
	buf.WriteByte('}')
	return buf.String()
}

func BitCount(x uint64) int {
	x = x - ((x >> 1) & 0x5555555555555555)
	x = (x & 0x3333333333333333) + ((x >> 2) & 0x3333333333333333)
	x = (x + (x >> 4)) & 0x0f0f0f0f0f0f0f0f
	x = x + (x >> 8)
	x = x + (x >> 16)
	x = x + (x >> 32)
	return int(x & 0x7f)
}

func (s *IntSet) Len() int {
	count := 0
	for _, word := range s.words {
		count += BitCount(word)
	}
	return count
}

func (s *IntSet) Remove(x int) {
	word, bit := x/64, uint(x%64)
	for word >= len(s.words) {
		return
	}
	s.words[word] &= ^(1 << bit)
}

func (s *IntSet) Clear() {
	for i, _ := range s.words {
		s.words[i] = 0
	}
}

func (s *IntSet) Copy() *IntSet {
	n := new(IntSet)
	for _, word := range s.words {
		n.words = append(n.words, word)
	}
	return n
}

func (s *IntSet) AddAll(list ...int) {
	for _, x := range list {
		s.Add(x)
	}
}

func (s *IntSet) IntersectWith(t *IntSet) {
	for i, tword := range t.words {
		if i < len(s.words) {
			s.words[i] &= tword
		}
	}
}

func (s *IntSet) DifferenceWith(t *IntSet) {
	for i, tword := range t.words {
		if i < len(s.words) {
			s.words[i] &= ^tword
		}
	}
}

func (s *IntSet) SymmetricDifference(t *IntSet) {
	n := t.Copy()
	n.DifferenceWith(s)
	s.DifferenceWith(t)
	s.UnionWith(n)
}

func (s *IntSet) Elems() []int {
	var elems []int
	for i, word := range s.words {
		for j := 0; j < 64; j++ {
			if word&(1<<uint(j)) != 0 {
				elems = append(elems, 64*i+j)
			}
		}
	}
	return elems
}

func main() {
	var x IntSet
	var y IntSet

	x.Add(1)
	x.Add(144)
	x.Add(9)
	fmt.Println(x.String())

	y.Add(9)
	y.Add(42)
	fmt.Println(y.String())

	x.UnionWith(&y)
	fmt.Println(x.String())

	fmt.Println(x.Has(9), x.Has(123))

	fmt.Println(x.Len())
	fmt.Println(y.Len())

	y.Remove(9)
	y.Remove(1)
	y.Remove(10000)
	fmt.Println(&y)

	y.Clear()
	fmt.Println(&y)

	var z *IntSet = x.Copy()
	fmt.Println(z)

	z.AddAll(1, 2, 3)
	fmt.Println(z)

	var m IntSet
	var n IntSet

	m.AddAll(1, 2, 3, 4)
	n.AddAll(1, 3, 4, 5)

	m.IntersectWith(&n)
	fmt.Println(&m)

	m.Clear()
	m.AddAll(1, 2, 3, 4, 5, 6)
	m.DifferenceWith(&n)
	fmt.Println(&m)

	m.Clear()
	n.Clear()
	m.AddAll(1, 2, 4)
	n.AddAll(1, 3, 4)
	m.SymmetricDifference(&n)
	fmt.Println(&m)
}
