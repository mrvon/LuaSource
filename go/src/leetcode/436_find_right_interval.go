package main

import (
	"fmt"
	"sort"
)

type Interval struct {
	Start int
	End   int
}

type WrapInternal struct {
	i Interval
	o int
}

type SortedInterval []WrapInternal

func (si SortedInterval) Len() int {
	return len(si)
}

func (si SortedInterval) Less(i, j int) bool {
	return si[i].i.Start <= si[j].i.Start
}

func (si SortedInterval) Swap(i, j int) {
	si[i], si[j] = si[j], si[i]
}

func findRightInterval(intervals []Interval) []int {
	var wrap_list []WrapInternal

	for i := 0; i < len(intervals); i++ {
		wrap_list = append(wrap_list, WrapInternal{
			intervals[i],
			i,
		})
	}

	right_index := make([]int, len(wrap_list))

	for i := 0; i < len(right_index); i++ {
		right_index[i] = -1
	}

	sort.Sort(SortedInterval(wrap_list))

	for i := 0; i < len(wrap_list); i++ {
		x := wrap_list[i]
		for j := i + 1; j < len(wrap_list); j++ {
			y := wrap_list[j]
			if x.i.End <= y.i.Start {
				right_index[x.o] = y.o
				break
			}
		}
	}

	return right_index
}

func main() {
	fmt.Println(findRightInterval([]Interval{{1, 2}}))
	fmt.Println(findRightInterval([]Interval{{3, 4}, {2, 3}, {1, 2}}))
	fmt.Println(findRightInterval([]Interval{{1, 4}, {2, 3}, {3, 4}}))
}
