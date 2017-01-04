/*
https://en.wikipedia.org/wiki/Interval_scheduling

Greedy polynomial solution
The following greedy algorithm does find the optimal solution:

1. Select the interval, x, with the earliest finishing time.
2. Remove x, and all intervals intersecting x, from the set of candidate intervals.
3. Continue until the set of candidate intervals is empty.
*/
package main

import (
	"fmt"
	"sort"
)

type Interval struct {
	Start int
	End   int
}

type SortedInterval []Interval

func (si SortedInterval) Len() int {
	return len(si)
}

func (si SortedInterval) Less(i, j int) bool {
	return si[i].End <= si[j].End
}

func (si SortedInterval) Swap(i, j int) {
	si[i], si[j] = si[j], si[i]
}

func is_conflict(x Interval, y Interval) bool {
	// Reverse judge, brilliant!
	if x.Start >= y.End || y.Start >= x.End {
		return false
	} else {
		return true
	}
}

func eraseOverlapIntervals(intervals []Interval) int {
	count := 0

	sort.Sort(SortedInterval(intervals))

	for len(intervals) > 0 {
		x := intervals[0]
		intervals = intervals[1:]

		for i := 0; i < len(intervals); {
			if is_conflict(x, intervals[i]) {
				// remove it
				count++
				copy(intervals[i:], intervals[i+1:])
				intervals = intervals[:len(intervals)-1]
			} else {
				i++
			}
		}
	}

	return count
}

func main() {
	fmt.Println(eraseOverlapIntervals([]Interval{{1, 2}, {2, 3}, {3, 4}, {1, 3}}))
	fmt.Println(eraseOverlapIntervals([]Interval{{1, 2}, {1, 2}, {1, 2}}))
	fmt.Println(eraseOverlapIntervals([]Interval{{1, 2}, {2, 3}}))
}
