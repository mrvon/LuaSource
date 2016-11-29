package main

/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */

func dfs(root *TreeNode, result [][]int, level int) [][]int {
	if root == nil {
		return result
	}

	if level >= len(result) {
		result = append(result, []int{})
	}
	result[level] = append(result[level], root.Val)

	result = dfs(root.Left, result, level+1)
	result = dfs(root.Right, result, level+1)

	return result
}

func levelOrderBottom(root *TreeNode) [][]int {
	var result [][]int
	result = dfs(root, result, 0)
	j := 0
	k := len(result) - 1
	for j < k {
		result[j], result[k] = result[k], result[j]
		j++
		k--
	}
	return result
}
