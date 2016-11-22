package main

/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */
func __kthSmallest(root *TreeNode, k int, c *int, v *int) {
	if root == nil {
		return
	}

	if root.Left == nil && root.Right == nil {
		(*c)++
		if *c == k {
			(*v) = root.Val
		}
		return
	}

	__kthSmallest(root.Left, k, c, v)

	(*c)++
	if *c == k {
		(*v) = root.Val
		return
	}

	__kthSmallest(root.Right, k, c, v)
}

func kthSmallest(root *TreeNode, k int) int {
	c := 0
	v := 0
	__kthSmallest(root, k, &c, &v)
	return v
}
