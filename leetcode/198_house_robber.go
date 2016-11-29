// Dynamic Programming
// S[i,j] = max(S[i+1,j], S[i+2,j] + N[i])
package main

type Key struct {
	l int
	r int
}

func get(m map[Key]int, l int, r int) int {
	k := Key{
		l: l,
		r: r,
	}
	return m[k]
}

func set(m map[Key]int, l int, r int, v int) {
	k := Key{
		l: l,
		r: r,
	}
	m[k] = v
}

func rob(nums []int) int {
	m := make(map[Key]int)

	for i := 0; i < len(nums); i++ {
		set(m, i, i, nums[i])
	}

	for s := 2; s <= len(nums); s++ {
		for i := 0; i < len(nums); i++ {
			j := i + s - 1

			s1 := 0
			if i+1 < len(nums) && j < len(nums) {
				s1 = get(m, i+1, j)
			}

			s2 := 0
			if i+2 < len(nums) && j < len(nums) {
				s2 = get(m, i+2, j)
			}
			s2 += nums[i]

			if s1 > s2 {
				set(m, i, j, s1)
			} else {
				set(m, i, j, s2)
			}
		}
	}

	return get(m, 0, len(nums)-1)
}
