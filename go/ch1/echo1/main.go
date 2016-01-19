// Echo1 prints its command-line arguments.
package main

import (
	"fmt"
	"os"
)

func main() {
	var str string
	var sep string

	fmt.Println(header)

	for i := 1; i < len(os.Args); i++ {
		str += sep + os.Args[i]
		sep = " "
	}

	fmt.Println(str)
}
