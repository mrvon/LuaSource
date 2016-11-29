package main

import "fmt"

func median_of_three(nums []int, left int, right int) int {
	if right-left <= 1 {
		return nums[left]
	}

	mid := (left + right) / 2
	x := nums[left]
	y := nums[mid]
	z := nums[right]

	if x >= y && x <= z {
		return x
	} else if y >= x && y <= z {
		return y
	} else {
		return z
	}
}

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

func __quick_sort(nums []int, left int, right int) {
	if right-left <= 0 {
		return
	}

	pivot := median_of_three(nums, left, right)

	lrange, rrange := three_way_partition(nums, left, right, pivot)
	__quick_sort(nums, left, lrange-1)
	__quick_sort(nums, rrange+1, right)
}

func quick_sort(nums []int) {
	__quick_sort(nums, 0, len(nums)-1)
}

func findContentChildren(g []int, s []int) int {
	quick_sort(g)
	quick_sort(s)

	count := 0

	for i := 0; i < len(g); i++ {
		g_factor := g[i]
		is_content := false

		for j := 0; j < len(s); j++ {
			size := s[j]
			if size >= g_factor {
				is_content = true
				// remove this cookie
				s[j] = 0
				break
			}
		}

		if !is_content {
			return count
		} else {
			count++
		}
	}

	return count
}

func main() {
	fmt.Println(findContentChildren([]int{1, 2, 3}, []int{1, 1}))
	fmt.Println(findContentChildren([]int{1, 2}, []int{1, 2, 3}))
}
