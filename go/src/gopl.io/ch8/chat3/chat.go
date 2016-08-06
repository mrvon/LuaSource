// Chat is a server that lets clients chat with each other.
// Exercise 8.14
// Exercise 8.15
package main

import (
	"bufio"
	"fmt"
	"log"
	"net"
	"time"
)

const (
	client_send_buff_size = 20
)

type client struct {
	channel chan<- string // an outgoing message channel
	name    string
}

var (
	entering = make(chan client)
	leaving  = make(chan client)
	messages = make(chan string) // all incoming client message
)

func broadcaster() {
	clients := make(map[client]bool) // all connected clients
	for {
		select {
		case msg := <-messages:
			// Broadcast incoming message to all
			// clients' outgoing message channels.
			for cli := range clients {
				if len(cli.channel) == cap(cli.channel) {
					// Cause we don't want to block here.
					// when buff is full, we discard this message directly.
					continue
				}
				cli.channel <- msg
			}

		case cli := <-entering:
			cli.channel <- "----------- Online List -----------"
			for other_cli := range clients {
				cli.channel <- other_cli.name
			}
			cli.channel <- "-----------------------------------"
			clients[cli] = true

		case cli := <-leaving:
			delete(clients, cli)
			close(cli.channel)
		}
	}
}

func handleConn(conn net.Conn) {
	input := bufio.NewScanner(conn)
	ok := input.Scan()
	if !ok {
		conn.Close()
		return
	}

	// first line is client's name
	who := input.Text()

	ch := make(chan string, client_send_buff_size) // outgoing client messages

	cli := client{
		channel: ch,
		name:    who,
	}

	go clientWriter(conn, ch)

	cli.channel <- "You are " + who
	messages <- who + " has arrived"
	entering <- cli

	reset := make(chan bool)

	go clientReader(conn, who, messages, reset)

	timeout := time.NewTimer(time.Minute)

loop:
	for {
		select {
		case <-timeout.C:
			break loop
		case r := <-reset:
			if r {
				timeout.Reset(time.Minute)
			} else {
				break loop
			}
		}
	}

	leaving <- cli
	messages <- who + " has left"
}

func clientReader(conn net.Conn, who string, ch chan<- string, reset chan<- bool) {
	input := bufio.NewScanner(conn)
	for input.Scan() {
		reset <- true
		ch <- who + ": " + input.Text()
	}
	reset <- false
	// NOTE: ignoring potential errors from input.Err()
}

func clientWriter(conn net.Conn, ch <-chan string) {
	for msg := range ch {
		fmt.Fprintln(conn, msg) // NOTE: ignoring network errors
	}
	conn.Close()
}

func main() {
	listener, err := net.Listen("tcp", "localhost:8000")
	if err != nil {
		log.Fatal(err)
	}

	go broadcaster()

	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Print(err)
			continue
		}
		go handleConn(conn)
	}
}
