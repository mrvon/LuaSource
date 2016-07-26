// Exercise 9.5:
// Write a program with two goroutines that send messages back and forth over
// two unbuffered channels in ping-pong fashion. How many communications per
// second can the program sustain
package main

import (
	"fmt"
	"time"
)

func main() {
	ping := make(chan int)
	pong := make(chan int)

	go func() {
		for {
			ping <- 0
			<-pong
		}
	}()

	count := 0

	now := time.Now()
	timeout := time.Tick(1 * time.Second)

loop:
	for {
		select {
		case n := <-ping:
			pong <- n
			count++
		case <-timeout:
			break loop
		}
	}

	fmt.Printf("Ping Pong %d times in %v ", count, time.Since(now))
}
