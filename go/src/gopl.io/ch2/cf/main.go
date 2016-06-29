// Cf converts its numeric argument to Celsius and Fahrenheit.
package main

import (
	"fmt"
	"os"
	"strconv"

	"gopl.io/ch2/tempconv"
)

func main() {
	// fmt.Println(tempconv.AbsoluteZeroC)
	// fmt.Println(tempconv.FreezingC)
	// fmt.Println(tempconv.BoilingC)

	// fmt.Println(tempconv.CToF(tempconv.AbsoluteZeroC))
	// fmt.Println(tempconv.CToF(tempconv.FreezingC))
	// fmt.Println(tempconv.CToF(tempconv.BoilingC))

	for _, arg := range os.Args[1:] {
		t, err := strconv.ParseFloat(arg, 64)

		if err != nil {
			fmt.Fprintf(os.Stderr, "cf: %v\n", err)
			return
		}

		f := tempconv.Fahrenheit(t)
		c := tempconv.Celsius(t)

		fmt.Printf("%s = %s, %s = %s\n",
			f, tempconv.FToC(f), c, tempconv.CToF(c))
	}
}
