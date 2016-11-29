package main

import "fmt"

func singleNumber(nums []int) []int {
	xor := 0

	// Let Two Single Number as a, b

	for i := 0; i < len(nums); i++ {
		xor ^= nums[i]
	}

	// Now, xor = a ^ b
	if xor == 0 {
		panic("xor == 0")
	}

	// Find the right-most bit-1 in xor
	var n_bit uint = 0
	for {
		if xor&0x1 != 0 {
			break
		}
		n_bit++
		xor = (xor >> 1)
	}

	// Build mask
	mask := (0x1 << n_bit)

	// Because in xor, every bit-1 indicate that a and b is different in this
	// bit. So we can split a and b into two group using mask.

	a := 0
	b := 0

	for i := 0; i < len(nums); i++ {
		if nums[i]&mask == 0 {
			a ^= nums[i]
		} else {
			b ^= nums[i]
		}
	}

	var arr []int
	arr = append(arr, a)
	arr = append(arr, b)

	return arr
}

func main() {
	fmt.Println(singleNumber([]int{1, 2, 1, 3, 2, 5}))
	fmt.Println(singleNumber([]int{1, 2, 7, 1, 2, 5}))
}
