// LSD (least significant digit first) string sort
// Only work for same length string
package main

import "fmt"

func lsd(a []string, w int) {
	// sort a[] on leading w characters
	n := len(a)
	r := 256
	aux := make([]string, n)

	for d := w - 1; d >= 0; d-- {
		// sort by key-indexed counting on dth char.
		count := make([]int, r+1) // compute frequency counts
		for i := 0; i < n; i++ {
			count[a[i][d]+1]++
		}

		for i := 0; i < r; i++ { // transform counts to indices
			count[i+1] += count[i]
		}

		for i := 0; i < n; i++ { // distribute
			aux[count[a[i][d]]] = a[i]
			count[a[i][d]]++
		}

		for i := 0; i < n; i++ { // copy back
			a[i] = aux[i]
		}
	}
}

func main() {
	license_plate_list := []string{
		"4PGC938",
		"2IYE230",
		"3CIO720",
		"1ICK750",
		"1OHV845",
		"4JZY524",
		"1ICK750",
		"3CIO720",
		"1OHV845",
		"1OHV845",
		"2RLA629",
		"2RLA629",
		"3ATW723",
	}

	lsd(license_plate_list, len(license_plate_list[0]))

	for i := 0; i < len(license_plate_list); i++ {
		fmt.Println(license_plate_list[i])
	}
}
