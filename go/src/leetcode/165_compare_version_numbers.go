package main

import (
	"fmt"
	"strconv"
	"strings"
)

func compareVersion(version1 string, version2 string) int {
	list_1 := strings.Split(version1, ".")
	list_2 := strings.Split(version2, ".")

	len_1 := len(list_1)
	len_2 := len(list_2)

	for i := 0; i < len_1 || i < len_2; i++ {
		r1 := 0
		r2 := 0

		if i < len_1 {
			r1, _ = strconv.Atoi(list_1[i])
		}
		if i < len_2 {
			r2, _ = strconv.Atoi(list_2[i])
		}

		if r1 < r2 {
			return -1
		} else if r1 > r2 {
			return 1
		}
	}

	return 0
}

func assert(result int, expect int) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %d, Get %d", expect, result))
	}
}

func main() {
	assert(compareVersion("1.0", "1"), 0)
	assert(compareVersion("0", "1"), -1)
	assert(compareVersion("1", "1"), 0)
	assert(compareVersion("2", "1"), 1)
	assert(compareVersion("0.1", "1.1"), -1)
	assert(compareVersion("1.1", "1.2"), -1)
	assert(compareVersion("1.2", "13.37"), -1)
	assert(compareVersion("1.1", "0.1"), 1)
	assert(compareVersion("1.2", "1.1"), 1)
	assert(compareVersion("13.2", "13.37"), -1)
	assert(compareVersion("13.3", "13.37"), -1)
	assert(compareVersion("13.31", "13.37"), -1)
	assert(compareVersion("13.37", "13.37"), 0)
	assert(compareVersion("13.370", "13.37"), 1)
	assert(compareVersion("13.37.1", "13.37"), 1)
}
