/*
Algorithm: Generation in lexicographic order
https://en.wikipedia.org/wiki/Permutation?oldformat=true

1.Find the largest index k such that a[k] < a[k + 1]. If no such index exists,
	the permutation is the last permutation.
2.Find the largest index l greater than k such that a[k] < a[l].
3.Swap the value of a[k] with that of a[l].
4.Reverse the sequence from a[k + 1] up to and including the final element a[n].
*/

package main

import (
	"fmt"
	"sort"
)

func next_permutation(arr []int) bool {
	n := len(arr) - 1

	k := -1
	for i := n - 1; i >= 0; i-- {
		if arr[i] < arr[i+1] {
			k = i
			break
		}
	}

	// last permutation
	if k == -1 {
		return false
	}

	l := n
	for i := n; i > k; i-- {
		if arr[k] < arr[i] {
			l = i
			break
		}
	}

	arr[k], arr[l] = arr[l], arr[k]

	i := k + 1
	j := n
	for i < j {
		arr[i], arr[j] = arr[j], arr[i]
		i++
		j--
	}

	return true
}

func main() {
	a1 := []int{1, 2, 3, 4}

	sort.Ints(a1)
	fmt.Println(a1)

	for next_permutation(a1) {
		fmt.Println(a1)
	}
}
