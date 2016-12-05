package main

import "fmt"

// An Item is something we manage in a priority queue.
type Item struct {
	key      int // The key of the item.
	value    int // The value of the item.
	priority int // The priority of the item in the queue.
	index    int // The index of the item in the heap.
}

type Heap []*Item

func (h Heap) Len() int {
	return len(h)
}

func (h Heap) Less(i, j int) bool {
	return h[i].priority <= h[j].priority
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

func (h *Heap) Remove(i int) *Item {
	n := h.Len() - 1
	if n != i {
		h.Swap(i, n)
		h.Down(i, n)
		h.Up(i)
	}
	return h.Pop()
}

// Fix re-establishes the heap ordering after the element at index i has changed its value.
// Changing the value of the element at index i and then calling Fix is equivalent to,
// but less expensive than, calling Remove(h, i) followed by a Push of the new value.
// The complexity is O(log(n)) where n = h.Len().
func (h *Heap) Fix(i int) {
	h.Down(i, h.Len())
	h.Up(i)
}

// update modifies the priority and value of an Item in the queue.
func (h *Heap) Update(item *Item) {
	h.Fix(item.index)
}

func main() {
	h := &Heap{}

	p := func(i *Item) {
		fmt.Printf("%d ITEM: (%d,%d)\n", i.priority, i.key, i.value)
	}

	h.Push(&Item{
		key:      1000,
		value:    10,
		priority: 1,
	})

	h.Push(&Item{
		key:      1001,
		value:    10,
		priority: 3,
	})

	h.Push(&Item{
		key:      1002,
		value:    10,
		priority: 4,
	})

	h.Push(&Item{
		key:      1003,
		value:    10,
		priority: 2,
	})

	u := &Item{
		key:      1004,
		value:    10,
		priority: 0,
	}
	h.Push(u)
	p(h.Pop())

	h.Push(u)
	u.priority = 5
	h.Update(u)

	for h.Len() > 0 {
		p(h.Pop())
	}
}
