package main

import "fmt"

type LFUCache struct {
	hash     map[int]int
	capacity int
}

func Constructor(capacity int) LFUCache {
	return LFUCache{
		capacity: capacity,
	}
}

func (this *LFUCache) Get(key int) int {
	return 0
}

func (this *LFUCache) Set(key int, value int) {
	return
}

func main() {
	capacity := 2
	obj := Constructor(capacity)
	obj.Set(1, 1)
	obj.Set(2, 2)
	fmt.Println(obj.Get(1))
	obj.Set(3, 3)
}
