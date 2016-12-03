package main

import "fmt"

const (
	UP   = 0
	DOWN = 1
)

func convert(s string, numRows int) string {
	if numRows <= 1 {
		return s
	}

	b := []byte(s)
	var matrix [][]byte

	for i := 0; i < numRows; i++ {
		matrix = append(matrix, make([]byte, (len(b)+1)/2))
	}

	// start point
	x := 0
	y := 0
	i := 0
	state := DOWN

	for i < len(b) {
		matrix[x][y] = b[i]

		i++
		// find next
		if state == DOWN {
			if x >= numRows-1 {
				x--
				y++
				state = UP
			} else {
				x++
			}
		} else { // state == UP
			if x <= 0 {
				x++
				state = DOWN
			} else {
				x--
				y++
			}
		}
	}

	var r []byte
	for i := 0; i < len(matrix); i++ {
		for j := 0; j < len(matrix[i]); j++ {
			if matrix[i][j] != 0 {
				r = append(r, matrix[i][j])
			}
		}
	}
	return string(r)
}

func assert(expect string, result string) {
	if result != expect {
		panic(fmt.Sprintf("Assert failed!, Expect %s, Get %s", expect, result))
	}
}
func main() {
	assert("PAYPALISHIRING", convert("PAYPALISHIRING", 1))
	assert("PYAIHRNAPLSIIG", convert("PAYPALISHIRING", 2))
	assert("PAHNAPLSIIGYIR", convert("PAYPALISHIRING", 3))
	assert("PINALSIGYAHRPI", convert("PAYPALISHIRING", 4))
}
