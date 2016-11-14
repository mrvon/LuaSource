package main

import "fmt"

type Trie struct {
	children [2]*Trie
}

func findMaximumXOR(nums []int) int {
	root := &Trie{}

	// build trie
	for i := 0; i < len(nums); i++ {
		n := nums[i]
		node := root
		j := 31

		// insert into trie

		for j >= 0 {
			b := (n >> uint(j)) & 0x1
			next := node.children[b]
			if next == nil {
				break
			} else {
				node = next
				j--
			}
		}

		for j >= 0 {
			b := (n >> uint(j)) & 0x1
			node.children[b] = &Trie{}
			node = node.children[b]
			j--
		}
	}

	max := 0

	for i := 0; i < len(nums); i++ {
		n := nums[i]
		node := root
		j := 31

		m := 0

		// greedy find reverse bit to build max result
		for j >= 0 {
			b := (n >> uint(j)) & 0x1
			if node.children[0x1^b] != nil {
				m = m | (0x1 ^ b)
				node = node.children[0x1^b]
			} else {
				m = m | b
				node = node.children[b]
			}
			if j > 0 {
				m = m << 1
			}
			j--
		}

		if n^m > max {
			max = n ^ m
		}
	}

	return max
}

func main() {
	fmt.Println(findMaximumXOR([]int{1, 0}))
	fmt.Println(findMaximumXOR([]int{1, 1}))
	fmt.Println(findMaximumXOR([]int{1, 2, 3}))
	fmt.Println(findMaximumXOR([]int{3, 10, 5, 25, 2, 8}))
}
