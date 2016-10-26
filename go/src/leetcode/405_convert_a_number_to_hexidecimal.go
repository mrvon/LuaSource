package main

import "fmt"

func toHex(num int) string {
	var list []rune
	var unum uint32 = uint32(num)

	if unum == 0 {
		return "0"
	}

	for unum > 0 {
		r := unum % 16
		unum /= 16

		var c rune

		if r == 15 {
			c = 'f'
		} else if r == 14 {
			c = 'e'
		} else if r == 13 {
			c = 'd'
		} else if r == 12 {
			c = 'c'
		} else if r == 11 {
			c = 'b'
		} else if r == 10 {
			c = 'a'
		} else {
			c = rune(r + '0')
		}

		list = append(list, c)
	}

	// reverse
	i := 0
	j := len(list) - 1
	for i < j {
		list[i], list[j] = list[j], list[i]
		i++
		j--
	}

	return string(list)
}

func main() {
	fmt.Println(toHex(0))
	fmt.Println(toHex(1))
	fmt.Println(toHex(16))
	fmt.Println(toHex(-1))
}
