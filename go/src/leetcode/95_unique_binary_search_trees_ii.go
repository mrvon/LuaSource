package main

import "fmt"

type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

func __copy(root *TreeNode) *TreeNode {
	if root == nil {
		return nil
	}

	new_root := &TreeNode{
		Val:   root.Val,
		Left:  __copy(root.Left),
		Right: __copy(root.Right),
	}

	return new_root
}

func __generate(l int, r int) []*TreeNode {
	var tree_list []*TreeNode

	if r-l < 0 {
		// NIL NODE
		tree_list = append(tree_list, nil)
		return tree_list
	} else if r-l == 0 {
		// ONE NODE
		tree_list = append(tree_list, &TreeNode{
			Val: l,
		})
		return tree_list
	}

	for i := l; i <= r; i++ {
		// select i as root

		left_tree_list := __generate(l, i-1)
		right_tree_list := __generate(i+1, r)

		for p := 0; p < len(left_tree_list); p++ {
			for q := 0; q < len(right_tree_list); q++ {
				root := &TreeNode{
					Val:   i,
					Left:  __copy(left_tree_list[p]),
					Right: __copy(right_tree_list[q]),
				}
				tree_list = append(tree_list, root)
			}
		}
	}

	return tree_list
}

func generateTrees(n int) []*TreeNode {
	if n <= 0 {
		return []*TreeNode{}
	}
	return __generate(1, n)
}

func main() {
	fmt.Println(generateTrees(0))
	fmt.Println(generateTrees(1))
	fmt.Println(generateTrees(2))
	fmt.Println(generateTrees(3))
	fmt.Println(generateTrees(4))
}
