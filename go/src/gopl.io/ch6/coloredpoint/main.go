package main

import (
	"fmt"
	"image/color"
	"math"
)

type Point struct {
	X float64
	Y float64
}

type ColoredPoint struct {
	Point
	Color color.RGBA
}

func (p Point) Distance(q Point) float64 {
	return math.Hypot(q.X-p.X, q.Y-p.Y)
}

func (p *Point) ScaleBy(factor float64) {
	p.X *= factor
	p.Y *= factor
}

func main() {
	var cp ColoredPoint
	cp.X = 1
	fmt.Println(cp.Point.X)
	fmt.Println(cp.X)
	cp.Point.Y = 2
	fmt.Println(cp.Point.Y)
	fmt.Println(cp.Y)

	red := color.RGBA{255, 0, 0, 255}
	blue := color.RGBA{0, 0, 255, 255}
	var p = ColoredPoint{Point{1, 1}, red}
	var q = ColoredPoint{Point{5, 4}, blue}

	fmt.Println(p.Distance(q.Point))
	p.ScaleBy(2)
	q.ScaleBy(2)
	fmt.Println(p.Distance(q.Point))

	distanceFromP := p.Distance         // method value
	fmt.Println(distanceFromP(q.Point)) // "5"

	var origin Point // {0, 0}
	fmt.Println(distanceFromP(origin))

	p = ColoredPoint{Point{1, 1}, red}
	scaleP := p.ScaleBy // method value
	scaleP(2)
	scaleP(3)
	scaleP(10)
	fmt.Println(p.X, p.Y)

	p_2 := Point{1, 1}
	q_2 := Point{5, 4}
	distance := Point.Distance
	fmt.Println(distance(p_2, q_2))
	fmt.Printf("%T\n", distance)

	scale := (*Point).ScaleBy
	fmt.Println(p_2)
	scale(&p_2, 2)
	fmt.Println(p_2)
	fmt.Printf("%T\n", scale)
}
