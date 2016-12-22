package main

import (
	"fmt"
	"math/rand"

	"github.com/fogleman/gg"
)

func main() {
	const W = 1024
	const H = 1024
	const N = 2000

	// fill with white background
	dc := gg.NewContext(W, H)
	dc.SetRGB(1, 1, 1)
	dc.Clear()

	s := 0
	for i := 1; i <= N; i++ {
		h := rand.Int() % H
		s += h

		// black point
		dc.SetRGB(0, 0, 0)
		dc.DrawPoint(float64(W*i)/float64(N), float64(h), 1.0)
		dc.Fill()

		// red point
		dc.SetRGB(1, 0, 0)
		dc.DrawPoint(float64(W*i)/float64(N), float64(s)/float64(i), 1.0)
		dc.Fill()
	}
	fmt.Printf("Mean (%d values): %f\n", N, float64(s)/N/H)
	dc.SavePNG("out.png")
}
