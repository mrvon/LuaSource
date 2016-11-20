package main

import "fmt"

const (
	S1 = 0
	S2 = 1
	S3 = 2
)

func lcs(x string, y string) int {
	m := len(x)
	n := len(y)

	c := [][]int{}
	b := [][]int{}
	for i := 0; i <= m; i++ {
		c = append(c, make([]int, n+1))
		b = append(b, make([]int, n+1))
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
				b[i][j] = S1
			} else if c[i-1][j] >= c[i][j-1] {
				c[i][j] = c[i-1][j]
				b[i][j] = S2
			} else {
				c[i][j] = c[i][j-1]
				b[i][j] = S3
			}
		}
	}

	print_lcs(x, b, m, n)
	fmt.Println()

	return c[m][n]
}

func print_lcs(s string, b [][]int, m int, n int) {
	if m == 0 || n == 0 {
		return
	}
	if b[m][n] == S1 {
		print_lcs(s, b, m-1, n-1)
		fmt.Printf("%c", s[m-1])
	} else if b[m][n] == S2 {
		print_lcs(s, b, m-1, n)
	} else {
		print_lcs(s, b, m, n-1)
	}
}

func main() {
	fmt.Println("GTCGTCGGAAGCCGGCCGAA")
	fmt.Println(lcs("ACCGGTCGAGTGCGCGGAAGCCGGCCGAA", "GTCGTTCGGAATGCCGTTGCTCTGTAAA"))
}
