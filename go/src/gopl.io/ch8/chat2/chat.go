// Chat is a server that lets clients chat with each other.
package main

import (
	"bufio"
	"fmt"
	"log"
	"net"
	"time"
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
	who := conn.RemoteAddr().String()

	ch := make(chan string) // outgoing client messages

	cli := client{
		channel: ch,
		name:    who,
	}

	go clientWriter(conn, ch)

	cli.channel <- "You are " + who
	messages <- who + " has arrived"
	entering <- cli

	go clientReader(conn, messages)

	// TODO
	tick := time.Tick(10 * time.Second)
	select {
	case <-tick:
		break
	}

	leaving <- cli
	messages <- who + " has left"
}

func clientReader(conn net.Conn, ch chan<- string) {
	input := bufio.NewScanner(conn)
	who := conn.RemoteAddr().String()
	for input.Scan() {
		ch <- who + ": " + input.Text()
	}
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
