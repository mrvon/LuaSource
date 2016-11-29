package main

/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */

func __pathSum(root *TreeNode, build []int, result [][]int, sum int) [][]int {
	if root.Left == nil && root.Right == nil {
		// LEAF NODE
		if sum == root.Val {
			// PUSH
			build = append(build, root.Val)
			// CREATE NEW SLICE!!!
			temp := make([]int, len(build))
			copy(temp, build)
			result = append(result, temp)
			// RESTORE
			build = build[:len(build)-1]
		}
		return result
	}

	if root.Left != nil {
		// PUSH
		build = append(build, root.Val)
		result = __pathSum(root.Left, build, result, sum-root.Val)
		// RESTORE
		build = build[:len(build)-1]
	}

	if root.Right != nil {
		// PUSH
		build = append(build, root.Val)
		result = __pathSum(root.Right, build, result, sum-root.Val)
		// RESTORE
		build = build[:len(build)-1]
	}

	return result
}

func pathSum(root *TreeNode, sum int) [][]int {
	var result [][]int

	if root == nil {
		// Must be EMPTY tree
		return result
	} else {
		result = __pathSum(root, []int{}, result, sum)
		return result
	}
}
