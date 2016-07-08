// Fetch downloads the URL and returns the
// name and lenght of the local file.
package main

import (
	"io"
	"log"
	"net/http"
	"os"
	"path"
)

func fetch(url string) (filename string, n int64, err error) {
	resp, err := http.Get(url)
	if err != nil {
		return "", 0, err
	}

	defer resp.Body.Close()

	local := path.Base(resp.Request.URL.Path)
	if local == "/" {
		local = "index.html"
	}

	f, err := os.Create(local)
	if err != nil {
		return "", 0, err
	}

	n, err = io.Copy(f, resp.Body)
	// Close file, but prefer error from Copy, if any.
	if closeErr := f.Close(); err != nil {
		err = closeErr
	}
	return local, n, err
}

func main() {
	for _, arg := range os.Args[1:] {
		filename, n, err := fetch(arg)
		if err != nil {
			log.Printf("fetch %s : %v\n", arg, err)
		} else {
			log.Printf("fetch %s (file:%s) (size:%d) successful\n", arg, filename, n)
		}
	}
}
