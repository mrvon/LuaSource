package main

import "fmt"

func addBinary(a string, b string) string {
	var s []byte

	c := 0
	i := len(a) - 1
	j := len(b) - 1

	for i >= 0 || j >= 0 || c == 1 {
		if i >= 0 {
			c += int(a[i] - '0')
			i--
		}
		if j >= 0 {
			c += int(b[j] - '0')
			j--
		}
		s = append(s, byte(c%2+'0'))
		c /= 2
	}

	l := 0
	r := len(s) - 1
	for l < r {
		s[l], s[r] = s[r], s[l]
		l++
		r--
	}

	return string(s)
}

func assert(expect string, result string) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %s, Get %s", expect, result))
	}
}

func main() {
	fmt.Println(addBinary("0", "0"))
	fmt.Println(addBinary("1", "11"))
}
