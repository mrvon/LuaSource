/*
Key Point:

If we have n tree node 1...n, we can select i-th node as root node from 1 to n,
to build a unique BST. When select i-th node as root, 1...i-1 node go to the
left subtree, i+1...n node go to the right subtree. We can solve this problem
recursively. we also optimize the recursive program using dynamic programming.
*/
package main

import "fmt"

// Recursive, TIME-LIMIT-EXCEEDED
func __numTrees(n int) int {
	if n <= 0 {
		return 1
	} else if n == 1 {
		return 1
	}

	sum := 0

	for i := 1; i <= n; i++ {
		// select i as root

		// left subtree
		c := numTrees(i - 1)

		// right subtree
		c *= numTrees(n - i)

		sum += c
	}

	return sum
}

// DP Solution, Accept
func numTrees(n int) int {
	result := make([]int, n+2)

	result[0] = 1
	result[1] = 1

	for j := 2; j <= n; j++ {
		sum := 0
		for i := 1; i <= j; i++ {
			c := result[i-1]
			c *= result[j-i]
			sum += c
		}
		result[j] = sum
	}

	return result[n]
}

func assert(expect int, result int) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %d, Get %d", expect, result))
	}
}

func main() {
	assert(__numTrees(0), numTrees(0))
	assert(__numTrees(1), numTrees(1))
	assert(__numTrees(2), numTrees(2))
	assert(__numTrees(3), numTrees(3))
	assert(__numTrees(4), numTrees(4))
	assert(__numTrees(5), numTrees(5))
	assert(__numTrees(6), numTrees(6))
	assert(__numTrees(7), numTrees(7))
}
