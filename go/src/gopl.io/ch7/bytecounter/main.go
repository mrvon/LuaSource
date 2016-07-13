package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
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

type countingWriter struct {
	count  *int64
	writer io.Writer
}

func (c countingWriter) Write(p []byte) (int, error) {
	n, err := c.writer.Write(p)
	if err == nil {
		*(c.count) += int64(n)
	}
	return n, err
}

func CountingWriter(w io.Writer) (io.Writer, *int64) {
	var count int64
	wrapper := &countingWriter{&count, w}
	return wrapper, wrapper.count
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

	stdout, count := CountingWriter(os.Stdout)
	stdout.Write([]byte("Hello world\n"))
	fmt.Println(*count)
	stdout.Write([]byte("Hello world\n"))
	fmt.Println(*count)
}
