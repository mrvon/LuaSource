package main

/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */
func maxDepth(root *TreeNode) int {
	if root != nil {
		x := maxDepth(root.Left)
		y := maxDepth(root.Right)
		if x > y {
			return x + 1
		} else {
			return y + 1
		}
	} else {
		return 0
	}
}
