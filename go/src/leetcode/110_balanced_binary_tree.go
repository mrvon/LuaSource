package main

/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */

func abs(v int) int {
	if v >= 0 {
		return v
	} else {
		return -v
	}
}

func max(x int, y int) int {
	if x >= y {
		return x
	} else {
		return y
	}
}

func deep(root *TreeNode, d int) int {
	if root == nil {
		return d - 1
	}

	return max(deep(root.Left, d+1),
		deep(root.Right, d+1))
}

func __isBalanced(root *TreeNode, d int) bool {
	if root == nil {
		return true
	}

	if abs(deep(root.Left, d)-deep(root.Right, d)) > 1 {
		return false
	} else {
		return __isBalanced(root.Left, d+1) && __isBalanced(root.Right, d+1)
	}
}

func isBalanced(root *TreeNode) bool {
	return __isBalanced(root, 0)
}
