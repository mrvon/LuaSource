// Solution using priority queue, O(n*log(k))
package main

import "fmt"

type Item struct {
	key      int
	priority int
	index    int
}

type Heap []*Item

func (h Heap) Len() int {
	return len(h)
}

func (h Heap) Less(i, j int) bool {
	return h[i].priority >= h[j].priority
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

func topKFrequent(nums []int, k int) []int {
	m := make(map[int]*Item)
	var h Heap

	for i := 0; i < len(nums); i++ {
		item := m[nums[i]]
		if item == nil {
			item = &Item{
				key:      nums[i],
				priority: 1,
			}
			m[nums[i]] = item
			h.Push(item)
		} else {
			item.priority++
			h.Update(item)
		}
	}

	var result []int
	for i := 0; i < k; i++ {
		item := h.Pop()
		result = append(result, item.key)
	}
	return result
}

func main() {
	fmt.Println(topKFrequent([]int{1, 1, 1, 2, 2, 3}, 2))
	fmt.Println(topKFrequent([]int{1, 1, 2, 2, 2, 3}, 2))
}
