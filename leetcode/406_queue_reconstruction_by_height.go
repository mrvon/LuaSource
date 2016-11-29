/*
Inspire by
https://discuss.leetcode.com/topic/60981/explanation-of-the-neat-sort-insert-solution

Key point is:

1. For taller people, shorter people is in the front or in the back of it is irrelevant.
	it's never effect taller people's k value. So, We can sort by rule: taller
	people first, and k value smaller first.

2. Insert people from begin to end. k value is the index this people want to standing.
    (Because every people in front of index k is taller than it) and
	insert into list only effect the position of the people who taller than it,
	it doesn't effect these taller people's k value. It's no problem.
*/
package main

import (
	"fmt"
	"sort"
)

type List [][]int

func (v List) Len() int {
	return len(v)
}

func (v List) Less(i, j int) bool {
	if v[i][0] > v[j][0] {
		return true
	} else if v[i][0] == v[j][0] {
		if v[i][1] <= v[j][1] {
			return true
		} else {
			return false
		}
	} else {
		return false
	}
}

func (v List) Swap(i, j int) {
	v[i], v[j] = v[j], v[i]
}

func reconstructQueue(people [][]int) [][]int {
	var l List = people

	sort.Sort(l)

	for i := 0; i < len(l); i++ {
		j := l[i][1]
		temp := l[i]
		copy(l[j+1:i+1], l[j:i])
		l[j] = temp
	}

	return l
}

func main() {
	fmt.Println(reconstructQueue([][]int{{7, 0}, {4, 4}, {7, 1}, {5, 0}, {6, 1}, {5, 2}}))
}
