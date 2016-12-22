package main

import (
	"math/rand"

	"github.com/fogleman/gg"
)

func main() {
	const W = 1024
	const H = 1024

	// fill with white background
	dc := gg.NewContext(W, H)
	dc.SetRGB(1, 1, 1)
	dc.Clear()

	// draw point
	dc.SetRGB(0, 0, 0)
	for i := 1; i <= W; i++ {
		for j := 1; j <= H; j++ {
			if rand.Int()%50 == 0 {
				dc.DrawPoint(float64(i), float64(j), 1.0)
			}
		}
	}
	dc.Fill()
	dc.SavePNG("out.png")
}
