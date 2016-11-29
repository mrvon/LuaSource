package main

import "fmt"

func removeElement(nums []int, val int) int {
	for i := 0; i < len(nums); {
		if nums[i] == val {
			nums[i] = nums[len(nums)-1]
			nums = nums[:len(nums)-1]
		} else {
			i++
		}
	}

	return len(nums)
}

func main() {
	arr := []int{1, 1, 2, 2, 3, 4}
	fmt.Println(removeElement(arr, 2))
	fmt.Println(arr)
}
