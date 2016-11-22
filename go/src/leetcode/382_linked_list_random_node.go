package main

/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
type Solution struct {
	head *ListNode
	size int
}

/** @param head The linked list's head.
  Note that the head is guaranteed to be not null, so it contains at least one node. */
func Constructor(head *ListNode) Solution {
	size := 0
	p := head
	for p != nil {
		size++
		p = p.Next
	}

	return Solution{
		head: head,
		size: size,
	}
}

/** Returns a random node's value. */
func (this *Solution) GetRandom() int {
	r := rand.Int() % this.size
	p := this.head
	for i := 0; i < r; i++ {
		p = p.Next
	}
	return p.Val
}

/**
 * Your Solution object will be instantiated and called as such:
 * obj := Constructor(head);
 * param_1 := obj.GetRandom();
 */
