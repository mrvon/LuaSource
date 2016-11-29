package main

/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */

// The key point is try to use every vertx as start point.
// up down to find the path, it guaranteed the path won't be duplicated.

func pathSum(root *TreeNode, sum int) int {
	if root == nil {
		return 0
	}

	return pathSum(root.Left, sum) + // path start from Left child
		pathSum(root.Right, sum) + // path start from Right child
		findPath(root, sum) // path start from Root
}

func findPath(root *TreeNode, sum int) int {
	if root == nil {
		return 0
	}

	count := 0

	if sum == root.Val {
		count++
	}

	count += findPath(root.Left, sum-root.Val)
	count += findPath(root.Right, sum-root.Val)

	return count
}
