// Charcount computes counts of Unicode characters.
package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"unicode"
	"unicode/utf8"
)

func main() {
	counts := make(map[rune]int)    // counts of Unicode characters
	var utflen [utf8.UTFMax + 1]int // count of lengths of UTF-8 encodings
	digits := 0                     // count of digits
	letters := 0                    // count of letters
	invalid := 0                    // count of invalid UTF-8 characters

	in := bufio.NewReader(os.Stdin)
	for {
		r, n, err := in.ReadRune() // returns rune, nbytes, error
		if err == io.EOF {
			break
		}

		if err != nil {
			fmt.Fprintf(os.Stderr, "charcount: %v\n", err)
			os.Exit(1)
		}

		if r == unicode.ReplacementChar && n == 1 {
			invalid++
			continue
		}

		counts[r]++
		utflen[n]++

		if unicode.IsLetter(r) {
			letters++
		} else if unicode.IsDigit(r) {
			digits++
		}
	}

	fmt.Printf("rune\tcount\n")

	for c, n := range counts {
		fmt.Printf("%q\t%d\n", c, n)
	}

	fmt.Print("\nlen\tcount\n")
	for i, n := range utflen {
		if i > 0 {
			fmt.Printf("%d\t%d\n", i, n)
		}
	}
	if invalid > 0 {
		fmt.Printf("\n%dinvalid UTF-8 characters\n", invalid)
	}

	fmt.Printf("Letters\t%d\n", letters)
	fmt.Printf("Digits\t%d\n", digits)
}
