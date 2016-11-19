package main

import "fmt"

func lcs(x string, y string) int {
	m := len(x)
	n := len(y)

	c := [][]int{}
	for i := 0; i <= m; i++ {
		c = append(c, make([]int, n+1))
	}

	for i := 0; i <= m; i++ {
		c[i][0] = 0
	}

	for j := 0; j <= n; j++ {
		c[0][j] = 0
	}

	for i := 1; i <= m; i++ {
		for j := 1; j <= n; j++ {
			if x[i-1] == y[j-1] {
				c[i][j] = c[i-1][j-1] + 1
			} else if c[i-1][j] >= c[i][j-1] {
				c[i][j] = c[i-1][j]
			} else {
				c[i][j] = c[i][j-1]
			}
		}
	}

	return c[m][n]
}

func main() {
	fmt.Println(lcs("ACCGGTCGAGTGCGCGGAAGCCGGCCGAA", "GTCGTTCGGAATGCCGTTGCTCTGTAAA"))
}
