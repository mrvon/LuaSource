package main

/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */
func __minDepth(root *TreeNode, cur_depth int) int {
	if root == nil {
		return math.MaxInt32
	} else if root.Left == nil && root.Right == nil {
		// Leave node
		return cur_depth
	}

	l := __minDepth(root.Left, cur_depth+1)
	r := __minDepth(root.Right, cur_depth+1)
	if l < r {
		return l
	} else {
		return r
	}
}

func minDepth(root *TreeNode) int {
	if root == nil {
		return 0
	}
	return __minDepth(root, 1)
}
