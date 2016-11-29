package main

import (
	"fmt"
	"sort"
)

type Item struct {
	num   int
	count int
}

type ItemList []Item

func (v ItemList) Len() int {
	return len(v)
}

func (v ItemList) Less(i, j int) bool {
	return v[i].count >= v[j].count
}

func (v ItemList) Swap(i, j int) {
	v[i], v[j] = v[j], v[i]
}

func topKFrequent(nums []int, k int) []int {
	dict := make(map[int]int)
	list := ItemList{}

	for _, n := range nums {
		dict[n]++
	}

	for n, c := range dict {
		item := Item{
			num:   n,
			count: c,
		}
		list = append(list, item)
	}

	sort.Sort(list)

	var arr []int

	for i := 0; i < k; i++ {
		arr = append(arr, list[i].num)
	}

	return arr
}

func main() {
	fmt.Println(topKFrequent([]int{1, 1, 1, 2, 2, 3}, 1))
	fmt.Println(topKFrequent([]int{1, 1, 1, 2, 2, 3}, 2))
	fmt.Println(topKFrequent([]int{1, 1, 1, 2, 2, 3}, 3))
	fmt.Println(topKFrequent([]int{1, 3, 3, 2, 2, 3}, 2))
}
