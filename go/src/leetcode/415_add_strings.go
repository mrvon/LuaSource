package main

import "fmt"

func addStrings(num1 string, num2 string) string {
	var arr1 []int
	var arr2 []int

	for _, r := range num1 {
		arr1 = append(arr1, int(r-'0'))
	}

	// reverse
	i := 0
	j := len(arr1) - 1
	for i < j {
		arr1[i], arr1[j] = arr1[j], arr1[i]
		i++
		j--
	}

	for _, r := range num2 {
		arr2 = append(arr2, int(r-'0'))
	}

	// reverse
	i = 0
	j = len(arr2) - 1
	for i < j {
		arr2[i], arr2[j] = arr2[j], arr2[i]
		i++
		j--
	}

	// plus
	len1 := len(arr1)
	len2 := len(arr2)

	lens := len1
	if len2 > lens {
		lens = len2
	}

	var sum []int

	for i := 0; i < lens+1; i++ {
		x := 0
		y := 0

		if i < len1 {
			x = arr1[i]
		}
		if i < len2 {
			y = arr2[i]
		}

		sum = append(sum, x+y)
	}

	for i := 0; i < len(sum)-1; i++ {
		if sum[i] >= 10 {
			sum[i] %= 10
			sum[i+1] += 1
		}
	}

	var result []rune

	index := len(sum) - 1
	if sum[index] == 0 {
		index--
	}

	for i := index; i >= 0; i-- {
		result = append(result, rune(sum[i]+'0'))
	}

	return string(result)
}

func main() {
	fmt.Println(addStrings("9", "9"))
	fmt.Println(addStrings("19", "9"))

	fmt.Println(addStrings(
		"401716832807512840963",
		"167141802233061013023557397451289113296441069",
	))
}
