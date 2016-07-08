package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

// WaitForServer attempts to contact the server of a URL.
// It tries for one minute using exponential back-off.
// It reports an error if all attempts fail.
func WaitForServer(url string) error {
	const timeout = 1 * time.Minute
	var deadline = time.Now().Add(timeout)
	for tries := 0; time.Now().Before(deadline); tries++ {
		_, err := http.Head(url)
		if err == nil {
			return nil // success
		}
		log.Printf("server not responding (%s); retrying...", err)
		time.Sleep(time.Second << uint(tries)) // exponential back-off
	}
	return fmt.Errorf("server %s failed to respond after %s", url, timeout)
}

func main() {
	url := os.Args[1]

	if err := WaitForServer(url); err != nil {
		log.Fatalf("Site is down: %v\n", err)
	}

	fmt.Println("OK")
}
