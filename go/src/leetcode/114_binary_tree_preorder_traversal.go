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

func (S *Stack) push(id *TreeNode) {
	S.S = append(S.S, id)
}

func (S *Stack) pop() (id *TreeNode) {
	id = S.S[len(S.S)-1]
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

func preorderTraversal(root *TreeNode) []int {
	var res []int
	if root == nil {
		return res
	}

	var s Stack

	s.push(root)

	for !s.isempty() {
		node := s.pop()
		res = append(res, node.Val)
		if node.Right != nil {
			s.push(node.Right)
		}
		if node.Left != nil {
			s.push(node.Left)
		}
	}

	return res
}

/* Recursive

func preorderTraversal(root *TreeNode) []int {
    var res []int
    res = traversal(root, res)
    return res
}

func traversal(root *TreeNode, res []int) []int {
    if root == nil {
        return res
    } else {
        res = append(res, root.Val)
        res = traversal(root.Left, res)
        res = traversal(root.Right, res)
        return res
    }
}

*/
