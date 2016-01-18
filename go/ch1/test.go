package main

import (
	"fmt"
	"image/color"
)

var palette = []color.Color{color.White, color.Black}

const (
	white_index = 0 // first color in palette
	black_index = 1 // next color in palette
)

func main() {
	fmt.Printf("%v\n", color.White)
	fmt.Printf("%v\n", color.Black)
	fmt.Printf("%v\n", white_index)
	fmt.Printf("%v\n", black_index)
	fmt.Printf("%v\n", palette[0])
	fmt.Printf("%v\n", palette[1])
}
