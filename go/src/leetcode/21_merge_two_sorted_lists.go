package main

/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */

// MUST BE Ascent sorted list
func mergeTwoLists(l1 *ListNode, l2 *ListNode) *ListNode {
	if l1 == nil {
		return l2
	} else if l2 == nil {
		return l1
	}

	p1 := l1
	p2 := l2

	var h *ListNode

	if p1.Val <= p2.Val {
		h = p1
		p1 = p1.Next
	} else {
		h = p2
		p2 = p2.Next
	}

	p := h

	for p1 != nil && p2 != nil {
		if p1.Val <= p2.Val {
			p.Next = p1
			p = p.Next
			p1 = p1.Next
		} else {
			p.Next = p2
			p = p.Next
			p2 = p2.Next
		}
	}

	if p1 == nil {
		p.Next = p2
	} else {
		p.Next = p1
	}

	return h
}
