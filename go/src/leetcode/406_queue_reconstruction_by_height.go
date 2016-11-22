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
