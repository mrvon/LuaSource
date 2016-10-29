package main

import (
	"fmt"
	"math/rand"
)

type RandomizedSet struct {
	m map[uint]int
	s []uint
}

/** Initialize your data structure here. */
func Constructor() RandomizedSet {
	set := RandomizedSet{}
	set.m = make(map[uint]int)
	return set
}

/** Inserts a value to the set. Returns true if the set did not already contain the specified element. */
func (this *RandomizedSet) Insert(val int) bool {
	uval := uint(val)

	// Next index for uval
	next := len(this.s)

	if this.m[uval] == 0 {
		// If uval not in set
		this.m[uval] = next + 1
		this.s = append(this.s, uval)
		return true
	} else {
		// If uval in set
		return false
	}
}

/** Removes a value from the set. Returns true if the set contained the specified element. */
func (this *RandomizedSet) Remove(val int) bool {
	uval := uint(val)

	if this.m[uval] == 0 {
		// If uval not is set
		return false
	} else {
		// If uval in set
		last_val := this.s[len(this.s)-1]
		this.m[last_val] = this.m[uval]
		this.s[this.m[uval]-1] = last_val
		this.m[uval] = 0
		// Remove last element
		this.s = this.s[:len(this.s)-1]
		return true
	}
}

/** Get a random element from the set. */
func (this *RandomizedSet) GetRandom() int {
	size := len(this.s)
	r := rand.Int() % size
	return int(this.s[r])
}

/**
 * Your RandomizedSet object will be instantiated and called as such:
 * obj := Constructor();
 * param_1 := obj.Insert(val);
 * param_2 := obj.Remove(val);
 * param_3 := obj.GetRandom();
 */
func main() {
	obj := Constructor()

	for i := 0; i < 100; i++ {
		obj.Insert(i)
		obj.Insert(-i)
	}

	for i := 0; i < 100; i++ {
		obj.Remove(i)
		obj.Remove(-i)
	}

	fmt.Println(obj.s)
}
