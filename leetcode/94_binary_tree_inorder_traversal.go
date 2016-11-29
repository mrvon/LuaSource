package main

/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */

/* Iterative */
type Stack struct {
	S []*TreeNode
}

func (S *Stack) push(node *TreeNode) {
	S.S = append(S.S, node)
}

func (S *Stack) pop() (node *TreeNode) {
	node = S.S[len(S.S)-1]
	S.S = S.S[:len(S.S)-1]
	return
}

func (S *Stack) isempty() bool {
	if len(S.S) == 0 {
		return true
	} else {
		return false
	}
}

func inorderTraversal(root *TreeNode) []int {
	var res []int

	var s Stack
	var node *TreeNode = root

	for (!s.isempty()) || (node != nil) {
		if node != nil {
			s.push(node)
			node = node.Left
		} else {
			node = s.pop()
			res = append(res, node.Val)
			node = node.Right
		}
	}

	return res
}

/* Recursive
func inorderTraversal(root *TreeNode) []int {
    var res []int
    res = traversal(root, res)
    return res
}

func traversal(root *TreeNode, res []int) []int {
    if root == nil {
        return res
    } else {
        res = traversal(root.Left, res)
        res = append(res, root.Val)
        res = traversal(root.Right, res)
        return res
    }
}
*/
