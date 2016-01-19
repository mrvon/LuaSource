// Echo2 prints its command-line arguments
package main

import (
	"fmt"
	"os"
)

func main() {
	str := ""
	sep := ""

	for _, arg := range os.Args[1:] {
		str += sep + arg
		sep = " "
	}

	fmt.Println(str)
}
