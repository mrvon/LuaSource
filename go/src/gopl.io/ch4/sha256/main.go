package main

import (
	"crypto/sha256"
	"fmt"
)

func diff_bit(c1, c2 [32]byte) int {
	var count int = 0

	for i := uint(0); i < 32; i++ {
		by1 := c1[i]
		by2 := c2[i]

		for j := uint(0); j < 8; j++ {
			bit_1 := by1 & (1 << j)
			bit_2 := by2 & (1 << j)

			if bit_1 != bit_2 {
				count++
			}
		}
	}

	return count
}

func main() {
	c1 := sha256.Sum256([]byte("x"))
	c2 := sha256.Sum256([]byte("X"))

	fmt.Printf("%x\n%x\n%t\n%T\n", c1, c2, c1 == c2, c1)
	fmt.Printf("Diff bit count: %d\n", diff_bit(c1, c2))
}
