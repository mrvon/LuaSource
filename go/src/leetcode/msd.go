package main

import "fmt"

const (
	R = 256
	M = 15
)

func msd(a []string) {
	aux := make([]string, len(a)-1)
	__msd(a, aux, 0, len(a)-1, 0)
}

func __msd(a []string, aux []string, left int, right int, d int) {
	// sort from a[left] to a[right], starting at the dth character.
	if left < right+M {
		__insert_sort(a, left, right, d)
	}

	count := make([]int, R+2)
	for i := left; i <= right; i++ { // compute frequency counts
		count[a[i][d]+2]++
	}

	for r := 0; r < R+1; r++ { // transform counts to indices
		count[r+1] += count[r]
	}

	for i := left; i <= right; i++ { // distribute
		aux[count[a[i][d]+1]] = a[i]
		count[a[i][d]+1]++
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
	for i := left + 1; i <= right; i++ {
		j := left
		for ; j < i; j++ {
			if a[i][d] < a[j][d] {
				break
			}
		}
		s := a[i]
		for k := j; k < i; k++ {
			a[k+1] = a[k]
		}
		a[j] = s
	}
}

func main() {
	a := []string{
		"hello",
		"world",
		"goodd",
	}
	fmt.Println(a)
	__insert_sort(a, 0, len(a)-1, 0)
	fmt.Println(a)
}
