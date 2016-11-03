package main

import "fmt"

func three_way_partition(nums []int, left int, right int, pivot int) (lrange int, rrange int) {
	i := left
	j := left
	k := right

	for j <= k {
		if nums[j] < pivot {
			nums[i], nums[j] = nums[j], nums[i]
			i++
			j++
		} else if nums[j] > pivot {
			nums[k], nums[j] = nums[j], nums[k]
			k--
		} else {
			j++
		}
	}

	lrange = i
	rrange = k
	return
}

func sortColors(nums []int) {
	white_color := 1
	three_way_partition(nums, 0, len(nums)-1, white_color)
}

func main() {
	colors := []int{0, 1, 1, 1, 1, 2, 2, 2, 0, 0, 0, 0}
	fmt.Println(colors)
	sortColors(colors)
	fmt.Println(colors)
}
