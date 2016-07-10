package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	word_freq := make(map[string]int)

	input := bufio.NewScanner(os.Stdin)
	input.Split(bufio.ScanWords)

	for input.Scan() {
		word := input.Text()
		word_freq[word]++
	}

	if err := input.Err(); err != nil {
		fmt.Fprintf(os.Stderr, "wordfreq: %v\n", err)
		os.Exit(1)
	}

	fmt.Println("---------------------- word freq ----------------------")
	for word, freq := range word_freq {
		fmt.Printf("%s\t%d\n", word, freq)
	}
}
