package main

import "fmt"

const (
	R = 256 // radix
	M = 15  // cutoff for small subarrays
)

func msd(a []string) {
	aux := make([]string, len(a)) // auxiliary array for distribution
	__msd(a, aux, 0, len(a)-1, 0)
}

func index(s string, i int) int {
	if i < len(s) {
		return int(s[i])
	} else {
		return -1
	}
}

func __msd(a []string, aux []string, left int, right int, d int) {
	// sort from a[left] to a[right], starting at the dth character.
	if right <= left+M {
		__insert_sort(a, left, right, d)
		return
	}

	count := make([]int, R+2)
	for i := left; i <= right; i++ { // compute frequency counts
		count[index(a[i], d)+2]++
	}

	for r := 0; r < R+1; r++ { // transform counts to indices
		count[r+1] += count[r]
	}

	for i := left; i <= right; i++ { // distribute
		aux[count[index(a[i], d)+1]] = a[i]
		count[index(a[i], d)+1]++
	}

	for i := left; i <= right; i++ { // copy back
		a[i] = aux[i-left]
	}

	// recursively sort for each character value
	for r := 0; r < R; r++ {
		__msd(a, aux, left+count[r], left+count[r+1]-1, d+1)
	}
}

func __insert_sort(a []string, left int, right int, d int) {
	for i := left; i <= right; i++ {
		for j := i; j > left && a[j][d] < a[j-1][d]; j-- {
			// exchange
			a[j], a[j-1] = a[j-1], a[j]
		}
	}
}

func main() {
	list := []string{
		"goa", "go", "goo", "flash", "to", "the", "zoo", "the", "game", "of",
		"world", "or", "and", "not", "bee", "box", "color",
	}
	msd(list)
	fmt.Println(list)
}
