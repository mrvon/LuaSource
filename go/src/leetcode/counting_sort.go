package main

import "fmt"

func counting_sort(a []int, r int) {
	n := len(a)
	aux := make([]int, n)
	count := make([]int, r+1)

	// compute frequency counts
	for i := 0; i < n; i++ {
		count[a[i]+1]++
	}

	// transform counts to indices
	for i := 0; i < r; i++ {
		count[i+1] += count[i]
	}

	// distribute the records
	for i := 0; i < n; i++ {
		aux[count[a[i]]] = a[i]
		count[a[i]]++
	}

	// copy back
	for i := 0; i < n; i++ {
		a[i] = aux[i]
	}
}

func main() {
	// key in an int in [0, R)
	list := []int{
		8, 1, 1, 1, 3, 4, 5, 6, 7, 3, 4, 5, 9, 10,
	}

	// here r is 11
	r := 11

	fmt.Println(list)
	counting_sort(list, r)
	fmt.Println(list)
}
