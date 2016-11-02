package main

/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */

type WrapNode struct {
	node  *TreeNode
	level int
}

type Stack struct {
	S []WrapNode
}

func (S *Stack) push(node *TreeNode, level int) {
	w := WrapNode{
		node:  node,
		level: level,
	}
	S.S = append(S.S, w)
}

func (S *Stack) pop() (*TreeNode, int) {
	w := S.S[len(S.S)-1]
	S.S = S.S[:len(S.S)-1]
	return w.node, w.level
}

func (S *Stack) isempty() bool {
	return len(S.S) == 0
}

func isSymmetric(root *TreeNode) bool {
	if root == nil {
		// EMPTY TREE
		return true
	}

	// BFS TRAVERSAL

	var s Stack
	var result [][]int

	s.push(root, 0)

	for !s.isempty() {
		node, level := s.pop()

		if level >= len(result) {
			result = append(result, []int{})
		}

		if node == nil {
			// I hope test case donot have MaxInt32
			// I just use it represent nil value of int type
			result[level] = append(result[level], math.MaxInt32)
		} else {
			result[level] = append(result[level], node.Val)
			s.push(node.Left, level+1)
			s.push(node.Right, level+1)
		}
	}

	// CHECK
	for i := 0; i < len(result); i++ {
		j := 0
		k := len(result[i]) - 1
		for j < k {
			if result[i][j] != result[i][k] {
				return false
			}
			j++
			k--
		}
	}

	return true
}
