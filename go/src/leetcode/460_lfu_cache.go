package main

import "fmt"

// An Item is something we manage in a priority queue.
type Item struct {
	key      int // The key of the item.
	value    int // The value of the item.
	priority int // The priority of the item in the queue.
	time     int // The timestamp of the item to be used.
	// The index is needed by update and is maintained by the heap.Interface methods.
	index int // The index of the item in the heap.
}

type Heap []*Item

func (h Heap) Len() int {
	return len(h)
}

func (h Heap) Less(i, j int) bool {
	if h[i].priority < h[j].priority {
		return true
	} else if h[i].priority == h[j].priority {
		return h[i].time <= h[j].time
	} else {
		return false
	}
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

func (h *Heap) Push(x interface{}) {
	n := h.Len()
	item := x.(*Item)
	item.index = n
	*h = append(*h, item)

	h.Up(h.Len() - 1)
}

func (h *Heap) Pop() interface{} {
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
	return h.Pop().(*Item)
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

type LFUCache struct {
	hash      map[int]*Item
	heap      Heap
	capacity  int
	current   int
	timestamp int
}

func Constructor(capacity int) LFUCache {
	return LFUCache{
		hash:      make(map[int]*Item),
		heap:      Heap{},
		capacity:  capacity,
		current:   0,
		timestamp: 0,
	}
}

func (this *LFUCache) Get(key int) int {
	item := this.hash[key]
	if item == nil {
		return -1
	}

	this.timestamp++

	item.time = this.timestamp
	item.priority = item.priority + 1
	this.heap.Update(item)

	return item.value
}

func (this *LFUCache) Set(key int, value int) {
	if this.capacity <= 0 {
		return
	}

	// try set
	item := this.hash[key]
	if item != nil {
		this.timestamp++
		item.time = this.timestamp
		item.priority = item.priority + 1
		item.value = value
		this.heap.Update(item)
		return
	}

	// just insert
	if this.current >= this.capacity {
		i := this.heap.Pop().(*Item)
		delete(this.hash, i.key)
	} else {
		this.current++
	}

	this.timestamp++

	item = &Item{
		key:      key,
		value:    value,
		priority: 0,
		time:     this.timestamp,
	}

	this.hash[key] = item
	this.heap.Push(item)
}

func assert(expect int, result int) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %d, Get %d", expect, result))
	}
}

func test_1() {
	capacity := 2
	obj := Constructor(capacity)
	obj.Set(1, 1)
	obj.Set(2, 2)
	assert(1, obj.Get(1))
	obj.Set(3, 3)
	assert(-1, obj.Get(2))
	assert(3, obj.Get(3))
	obj.Set(4, 4)
	assert(-1, obj.Get(1))
	assert(3, obj.Get(3))
	assert(4, obj.Get(4))
	obj.Set(3, 1)
	assert(1, obj.Get(3))
}

func test_2() {
	capacity := 2
	obj := Constructor(capacity)
	obj.Set(2, 1)
	obj.Set(1, 1)
	obj.Set(2, 3)
	obj.Set(4, 1)
	assert(-1, obj.Get(1))
	assert(3, obj.Get(2))
}

func test_3() {
	capacity := 0
	obj := Constructor(capacity)
	obj.Set(0, 0)
	assert(-1, obj.Get(0))
}

func main() {
	test_1()
	test_2()
	test_3()
}
