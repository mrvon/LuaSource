package main

import (
	"fmt"
	"io"
	"io/ioutil"
	"os"

	"golang.org/x/net/html"
)

// Exercise 7.4
type MyReader struct {
	s string // input string
	i int    // read index
}

func (r *MyReader) Read(p []byte) (n int, err error) {
	if len(p) == 0 {
		return 0, nil
	}

	n = copy(p, r.s[r.i:])
	r.i += n

	if n < len(p) {
		return n, io.EOF
	} else {
		return n, nil
	}
}

func new_my_reader(s string) *MyReader {
	return &MyReader{
		s: s,
	}
}

func main() {
	data, err := ioutil.ReadAll(os.Stdin)
	if err != nil {
		fmt.Fprintf(os.Stderr, "outline; %v\n", err)
		os.Exit(1)
	}

	reader := new_my_reader(string(data))

	doc, err := html.Parse(reader)

	if err != nil {
		fmt.Fprintf(os.Stderr, "outline; %v\n", err)
		os.Exit(1)
	}

	outline(nil, doc)
}

func outline(stack []string, n *html.Node) {
	if n.Type == html.ElementNode {
		stack = append(stack, n.Data) // push tag
		fmt.Println(stack)
	}
	for c := n.FirstChild; c != nil; c = c.NextSibling {
		outline(stack, c)
	}
}
