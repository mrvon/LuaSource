package main

/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */

func hasPathSum(root *TreeNode, sum int) bool {
	if root == nil {
		// Must be Empty tree
		return false
	} else if root.Left == nil && root.Right == nil {
		// LEAF NODE
		if sum == root.Val {
			return true
		} else {
			return false
		}
	} else {
		r1 := false
		r2 := false

		if root.Left != nil {
			r1 = hasPathSum(root.Left, sum-root.Val)
		}

		if root.Right != nil {
			r2 = hasPathSum(root.Right, sum-root.Val)
		}

		return r1 || r2
	}
}
