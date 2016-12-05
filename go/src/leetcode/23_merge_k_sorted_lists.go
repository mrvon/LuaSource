package main

/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */

// An Item is something we manage in a priority queue.
type Item struct {
	node  *ListNode
	index int // The index of the item in the heap.
}

type Heap []*Item

func (h Heap) Len() int {
	return len(h)
}

func (h Heap) Less(i, j int) bool {
	return h[i].node.Val < h[j].node.Val
}

func (h Heap) Swap(i, j int) {
	h[i], h[j] = h[j], h[i]
	h[i].index = i
	h[j].index = j
}

func (h *Heap) Up(j int) {
	for {
		i := (j - 1) / 2 // parent
		if i == j || !h.Less(j, i) {
			break
		}
		h.Swap(i, j)
		j = i
	}
}

func (h *Heap) Down(i int, n int) {
	for {
		j1 := 2*i + 1
		if j1 >= n || j1 < 0 {
			break
		}
		j := j1 // left child
		j2 := j1 + 1
		if j2 < n && !h.Less(j1, j2) {
			j = j2 // = 2*i + 2 // right child
		}
		if !h.Less(j, i) {
			break
		}
		h.Swap(i, j)
		i = j
	}
}

func (h *Heap) Push(item *Item) {
	n := h.Len()
	item.index = n
	*h = append(*h, item)

	h.Up(h.Len() - 1)
}

func (h *Heap) Pop() *Item {
	n := h.Len() - 1

	h.Swap(0, n)
	h.Down(0, n)

	item := (*h)[n]
	item.index = -1 // for safety
	*h = (*h)[0:n]

	return item
}

func (h *Heap) Fix(i int) {
	h.Down(i, h.Len())
	h.Up(i)
}

func (h *Heap) Update(item *Item) {
	h.Fix(item.index)
}

func mergeKLists(lists []*ListNode) *ListNode {
	h := &Heap{}

	if len(lists) == 0 {
		return nil
	}

	for i := 0; i < len(lists); i++ {
		if lists[i] != nil {
			h.Push(&Item{
				node: lists[i],
			})
		}
	}

	// build singly linked list
	var head *ListNode = nil
	var tail *ListNode = nil

	for h.Len() > 0 {
		item := h.Pop()

		if head == nil {
			head = &ListNode{
				Val:  item.node.Val,
				Next: nil,
			}
			tail = head
		} else {
			new_node := &ListNode{
				Val:  item.node.Val,
				Next: nil,
			}
			tail.Next = new_node
			tail = new_node
		}

		item.node = item.node.Next
		if item.node != nil {
			h.Push(item)
		}
	}

	return head
}
