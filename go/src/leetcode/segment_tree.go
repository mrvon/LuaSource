package main

import "fmt"

func merge(x int, y int) int {
	return x + y
}

func build(arr []int, low int, high int, tree []int, tree_index int) {
	if low == high { // leaf node, store value in node.
		tree[tree_index] = arr[low]
		return
	}

	mid := low + (high-low)/2 // recursive deeper for children.

	build(arr, low, mid, tree, 2*tree_index+1)    // left child
	build(arr, mid+1, high, tree, 2*tree_index+2) // right child

	// merge build results
	tree[tree_index] = merge(tree[2*tree_index+1], tree[2*tree_index+2])
}

func query(low int, high int, i int, j int, tree []int, tree_index int) int {
	// query for arr[i...j]

	if low > j || high < i { // segment completely outside range
		return 0 // represents a null node
	}

	if i <= low && j >= high { // segment completely inside range
		return tree[tree_index]
	}

	mid := low + (high-low)/2 // partial overlap of current segment and queried ranges. Recursive deeper.

	if j <= mid {
		return query(low, mid, i, j, tree, 2*tree_index+1)
	} else if i > mid {
		return query(mid+1, high, i, j, tree, 2*tree_index+2)
	}

	left_query := query(low, mid, i, mid, tree, 2*tree_index+1)
	right_query := query(mid+1, high, mid+1, j, tree, 2*tree_index+2)

	// merge query results
	return merge(left_query, right_query)
}

func update(low int, high int, arr_index int, val int, tree []int, tree_index int) {
	if low == high { // leaf node, update element
		tree[tree_index] = val
		return
	}

	mid := low + (high-low)/2

	if arr_index <= mid {
		update(low, mid, arr_index, val, tree, 2*tree_index+1)
	} else if arr_index > mid {
		update(mid+1, high, arr_index, val, tree, 2*tree_index+2)
	}

	// merge updates
	tree[tree_index] = merge(tree[2*tree_index+1], tree[2*tree_index+2])
}

// Build a segment tree from arr
func build_segtree(arr []int) []int {
	tree := make([]int, len(arr)*4)
	build(arr, 0, len(arr)-1, tree, 0)
	return tree
}

// Here [i,j] is the range/interval you are querying.
// This method relies on "null" nodes being equivalent to storing zero.
func query_segtree(arr []int, i int, j int, tree []int) int {
	return query(0, len(arr)-1, i, j, tree, 0)
}

func update_segtree(arr []int, arr_index int, val int, tree []int) {
	arr[arr_index] = val
	update(0, len(arr)-1, arr_index, val, tree, 0)
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
	assert(183, query_segtree(arr, 0, len(arr)-1, tree))
	assert(183, query_segtree(arr, 0, len(arr)+100, tree))
	assert(18, query_segtree(arr, 0, 0, tree))
	assert(17, query_segtree(arr, 1, 1, tree))
	assert(sum(arr, 0, 1), query_segtree(arr, 0, 1, tree))
	assert(sum(arr, 2, 8), query_segtree(arr, 2, 8, tree))
	assert(sum(arr, 4, 6), query_segtree(arr, 4, 6, tree))
	assert(sum(arr, 3, 7), query_segtree(arr, 3, 7, tree))

	update_segtree(arr, 0, 1024, tree)
	fmt.Println("ARR", arr)

	assert(1024, query_segtree(arr, 0, 0, tree))
	assert(1024+17, query_segtree(arr, 0, 1, tree))
}
