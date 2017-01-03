package main

import "fmt"

func hammingDistance(x int, y int) int {
	z := x ^ y
	c := 0

	for z > 0 {
		z &= z - 1
		c++
	}

	return c
}

func hammingDistance2(x int, y int) int {
	toBinary := func(i int32) []int32 {
		if i == 0 {
			return []int32{0}
		}

		u := uint32(i)
		var bin []int32

		for u > 0 {
			bin = append(bin, int32(u%2))
			u /= 2
		}
		return bin
	}

	x32 := int32(x)
	y32 := int32(y)
	count := 0

	xbin := toBinary(x32)
	ybin := toBinary(y32)

	for i := 0; i < len(xbin) || i < len(ybin); i++ {
		var xb int32 = 0
		var yb int32 = 0
		if i < len(xbin) {
			xb = xbin[i]
		}
		if i < len(ybin) {
			yb = ybin[i]
		}
		if xb != yb {
			count++
		}
	}

	return count
}

func main() {
	fmt.Println(hammingDistance(1, 4))
}
