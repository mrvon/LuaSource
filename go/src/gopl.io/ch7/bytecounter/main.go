package main

import (
	"bufio"
	"fmt"
)

type ByteCounter int

func (c *ByteCounter) Write(p []byte) (int, error) {
	*c += ByteCounter(len(p)) // convert int to ByteCounter
	return len(p), nil
}

type WordCounter int

func (c *WordCounter) Write(p []byte) (int, error) {
	base := 0
	for {
		advance, token, _ := bufio.ScanWords(p[base:], true)

		if len(token) == 0 {
			return len(p), nil
		}

		base += advance

		*c += 1
	}
}

type LineCounter int

func (c *LineCounter) Write(p []byte) (int, error) {
	base := 0
	for {
		advance, token, _ := bufio.ScanLines(p[base:], true)

		if len(token) == 0 {
			return len(p), nil
		}

		base += advance

		*c += 1
	}
}

func main() {
	var c ByteCounter
	c.Write([]byte("hello"))
	fmt.Println(c)

	c = 0 // reset the counter
	var name = "Dolly"
	fmt.Fprintf(&c, "hello, %s", name)
	fmt.Println(c)

	var c2 WordCounter
	c2.Write([]byte("hello world go go go"))
	fmt.Println(c2)

	var c3 LineCounter
	c3.Write([]byte("hello world \ngo go\n go"))
	fmt.Println(c3)
}
