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

func (S *Stack) peek() (id *TreeNode) {
	id = S.S[len(S.S)-1]
	return
}

func (S *Stack) isempty() bool {
	if len(S.S) == 0 {
		return true
	} else {
		return false
	}
}

func postorderTraversal(root *TreeNode) []int {
	var res []int
	if root == nil {
		return res
	}

	var s Stack
	var node *TreeNode = root
	var lastNodeVisited *TreeNode = nil

	for !s.isempty() || (node != nil) {
		if node != nil {
			s.push(node)
			node = node.Left
		} else {
			var peekNode *TreeNode = s.peek()
			// if right child exists and traversing node
			// from left child, then move right
			if peekNode.Right != nil && lastNodeVisited != peekNode.Right {
				node = peekNode.Right
			} else {
				res = append(res, peekNode.Val)
				lastNodeVisited = s.pop()
			}
		}
	}

	return res
}

/* Recursive
func postorderTraversal(root *TreeNode) []int {
    var res []int
    res = traversal(root, res)
    return res
}

func traversal(root *TreeNode, res []int) []int {
    if root == nil {
        return res
    } else {
        res = traversal(root.Left, res)
        res = traversal(root.Right, res)
        res = append(res, root.Val)
        return res
    }
}
*/
