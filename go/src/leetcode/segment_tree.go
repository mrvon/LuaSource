package main

import "fmt"

func merge(x int, y int) int {
	return x + y
}

func build(arr []int, tree []int, low int, high int, tree_index int) {
	if low == high { // leaf node, store value in node.
		tree[tree_index] = arr[low]
		return
	}

	mid := low + (high-low)/2 // recursive deeper for children.

	build(arr, tree, low, mid, 2*tree_index+1)    // left child
	build(arr, tree, mid+1, high, 2*tree_index+2) // right child

	// merge build results
	tree[tree_index] = merge(tree[2*tree_index+1], tree[2*tree_index+2])
}

func query(tree []int, low int, high int, i int, j int, tree_index int) int {
	// query for arr[i...j]

	if low > j || high < i { // segment completely outside range
		return 0 // represents a null node
	}

	if i <= low && j >= high { // segment completely inside range
		return tree[tree_index]
	}

	mid := low + (high-low)/2 // partial overlap of current segment and queried ranges. Recursive deeper.

	if j <= mid {
		return query(tree, low, mid, i, j, 2*tree_index+1)
	} else if i > mid {
		return query(tree, mid+1, high, i, j, 2*tree_index+2)
	}

	left_query := query(tree, low, mid, i, mid, 2*tree_index+1)
	right_query := query(tree, mid+1, high, mid+1, j, 2*tree_index+2)

	return merge(left_query, right_query)
}

// Build a segment tree from arr
func build_segtree(arr []int) []int {
	tree := make([]int, len(arr)*4)
	build(arr, tree, 0, len(arr)-1, 0)
	return tree
}

// Here [i,j] is the range/interval you are querying.
// This method relies on "null" nodes being equivalent to storing zero.
func query_segtree(arr []int, tree []int, i int, j int) int {
	return query(tree, 0, len(arr)-1, i, j, 0)
}

func assert(expect int, result int) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %d, Get %d", expect, result))
	}
}

func sum(arr []int, i int, j int) int {
	s := 0
	for k := i; k <= j; k++ {
		s += arr[k]
	}
	return s
}

func main() {
	arr := []int{
		18, 17, 13, 19, 15, 11, 20, 12, 33, 25,
	}
	tree := build_segtree(arr)

	fmt.Println("ARR", arr)
	fmt.Println("TREE", tree)
	assert(183, query_segtree(arr, tree, 0, len(arr)-1))
	assert(183, query_segtree(arr, tree, 0, len(arr)+100))
	assert(18, query_segtree(arr, tree, 0, 0))
	assert(17, query_segtree(arr, tree, 1, 1))
	assert(sum(arr, 0, 1), query_segtree(arr, tree, 0, 1))
	assert(sum(arr, 2, 8), query_segtree(arr, tree, 2, 8))
	assert(sum(arr, 4, 6), query_segtree(arr, tree, 4, 6))
	assert(sum(arr, 3, 7), query_segtree(arr, tree, 3, 7))
}
