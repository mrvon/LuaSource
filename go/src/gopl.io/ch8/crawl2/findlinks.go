// Usage
// $ ./crawl2 -depth 0 https://mrvon.github.io/
// $ ./crawl2 -depth 1 https://mrvon.github.io/
package main

import (
	"flag"
	"fmt"
	"log"

	"gopl.io/ch5/links"
)

// tokens is a counting semaphore used to
// enforce a limit of 20 concurrent requests.
var tokens = make(chan struct{}, 20)
var depth_limit = flag.Uint64("depth", 0, "depth limit")

type work_item struct {
	list  []string
	depth uint64
}

func crawl(url string) []string {
	fmt.Println(url)
	tokens <- struct{}{} // acquire a token
	list, err := links.Extract(url)
	<-tokens // release the token
	if err != nil {
		log.Print(err)
	}
	return list
}

func main() {
	flag.Parse()

	worklist := make(chan work_item)
	var n int // number of pending sends to worklist

	// Start with the command-line arguments.
	n++
	go func() {
		worklist <- work_item{
			flag.Args(),
			0,
		}
	}()

	// Crawl the web concurrently
	seen := make(map[string]bool)
	for ; n > 0; n-- {
		item := <-worklist
		if *depth_limit > 0 && item.depth > *depth_limit {
			continue
		}

		for _, link := range item.list {
			if !seen[link] {
				seen[link] = true
				n++
				go func(link string) {
					worklist <- work_item{
						crawl(link),
						item.depth + 1,
					}
				}(link)
			}
		}
	}
}
