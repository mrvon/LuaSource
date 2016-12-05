package main

/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func addTwoNumbers(l1 *ListNode, l2 *ListNode) *ListNode {
	var result []int

	for l1 != nil && l2 != nil {
		result = append(result, l1.Val+l2.Val)
		l1 = l1.Next
		l2 = l2.Next
	}

	for l1 != nil {
		result = append(result, l1.Val)
		l1 = l1.Next
	}

	for l2 != nil {
		result = append(result, l2.Val)
		l2 = l2.Next
	}

	// build singly linked list
	var lh *ListNode = nil // head
	var lt *ListNode = nil // tail

	for i := 0; i < len(result); i++ {
		if result[i] >= 10 {
			if i == len(result)-1 {
				result = append(result, 0)
			}
			result[i+1]++
			result[i] %= 10
		}

		if lh == nil {
			lh = &ListNode{
				Val:  result[i],
				Next: nil,
			}
			lt = lh
		} else {
			node := &ListNode{
				Val:  result[i],
				Next: nil,
			}
			lt.Next = node
			lt = node
		}
	}

	return lh
}
