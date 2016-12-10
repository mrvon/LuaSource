// Solution using bucket sort, O(n)
package main

import "fmt"

func topKFrequent(nums []int, k int) []int {
	m := make(map[int]int)

	for i := 0; i < len(nums); i++ {
		m[nums[i]]++
	}

	// build bucket
	bucket_list := make([][]int, len(nums)+1)
	for n, f := range m {
		bucket_list[f] = append(bucket_list[f], n)
	}

	// build result
	var result []int
	for i := len(bucket_list) - 1; i >= 0; i-- {
		bucket := bucket_list[i]
		for j := 0; j < len(bucket); j++ {
			result = append(result, bucket[j])
			if len(result) >= k {
				return result
			}
		}
	}
	return result
}

func main() {
	fmt.Println(topKFrequent([]int{1, 1, 1, 2, 2, 3}, 2))
	fmt.Println(topKFrequent([]int{1, 1, 2, 2, 2, 3}, 2))
	fmt.Println(topKFrequent([]int{1, 1, 1, 2, 2, 2, 3}, 2))
}
