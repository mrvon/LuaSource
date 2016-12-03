package main

/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */

func remove(head *ListNode, n int) (*ListNode, int) {
	if head == nil {
		return head, 0
	}

	k := 0
	head.Next, k = remove(head.Next, n)
	k += 1

	if k == n {
		// Remove nth element
		return head.Next, k
	}

	return head, k
}

func removeNthFromEnd(head *ListNode, n int) *ListNode {
	head, _ = remove(head, n)
	return head
}
