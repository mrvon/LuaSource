package main

import "fmt"

func min(x int, y int) int {
	if x <= y {
		return x
	} else {
		return y
	}
}

func maxArea(height []int) int {
	if len(height) < 2 {
		return 0
	}

	max_area := 0
	l_range := 0
	r_range := len(height) - 1

	for l_range < r_range {
		m := min(height[l_range], height[r_range]) * (r_range - l_range)
		if m > max_area {
			max_area = m
		}

		if height[l_range] <= height[r_range] {
			l_range++
		} else {
			r_range--
		}
	}

	return max_area
}

func main() {
	fmt.Println(maxArea([]int{1, 2, 2, 3, 4, 6}))
}
