/*
Algorithm:

n-bit Gray Codes can be generated from list of (n-1)-bit Gray codes using following steps.

1) Let the list of (n-1)-bit Gray codes be L1. Create another list L2 which is reverse of L1.
2) Modify the list L1 by prefixing a ‘0’ in all codes of L1.
3) Modify the list L2 by prefixing a ‘1’ in all codes of L2.
4) Concatenate L1 and L2. The concatenated list is required list of n-bit Gray codes.

For example, following are steps for generating the 3-bit Gray code list from
the list of 2-bit Gray code list.

L1 = {00, 01, 11, 10} (List of 2-bit Gray Codes)
L2 = {10, 11, 01, 00} (Reverse of L1)
Prefix all entries of L1 with ‘0’, L1 becomes {000, 001, 011, 010}
Prefix all entries of L2 with ‘1’, L2 becomes {110, 111, 101, 100}
Concatenate L1 and L2, we get {000, 001, 011, 010, 110, 111, 101, 100}

To generate n-bit Gray codes, we start from list of 1 bit Gray codes. The list
of 1 bit Gray code is {0, 1}. We repeat above steps to generate 2 bit Gray codes
from 1 bit Gray codes, then 3-bit Gray codes from 2-bit Gray codes till the
number of bits becomes equal to n.
*/

package main

import "fmt"

func generate_graycode(n int) []string {
	var code_list []string

	if n <= 0 {
		return code_list
	}

	// start with one-bit pattern
	code_list = append(code_list, "0")
	code_list = append(code_list, "1")

	// length of code list
	l := 2

	for j := 2; j <= n; j++ {
		// copy previous code list and reverse append.
		for i := l - 1; i >= 0; i-- {
			code_list = append(code_list, code_list[i])
		}

		// append 0 to the first half
		for i := 0; i < l; i++ {
			code_list[i] = "0" + code_list[i]
		}

		// append 1 to the second half
		for i := l; i < 2*l; i++ {
			code_list[i] = "1" + code_list[i]
		}

		l *= 2
	}

	return code_list
}

func main() {
	fmt.Println(generate_graycode(0))
	fmt.Println(generate_graycode(1))
	fmt.Println(generate_graycode(2))
	fmt.Println(generate_graycode(3))
	fmt.Println(generate_graycode(4))
}
