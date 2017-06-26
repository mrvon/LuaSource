package gate

import (
	"log"
	"net"
	"time"
)

const (
	SocketOpen = iota
	SocketClose
	SocketData
)

const (
	buffSize = 1024
)

type Packet struct {
	id       int
	packtype int
	buffer   []byte
}

func Start(packetChan chan<- Packet) {
	go Run(packetChan)
}

func Run(packetChan chan<- Packet) {
	id := 0

	listener, err := net.Listen("tcp", "localhost:8000")
	if err != nil {
		log.Fatal(err)
	}

	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Print(err)
			continue
		}
		id++
		go handleConn(id, conn, packetChan)
	}
}

func handleConn(id int, conn net.Conn, packetChan chan<- Packet) {
	defer conn.Close()
	conn.SetDeadline(time.Time{})
	buffer := make([]byte, buffSize)

	packetChan <- Packet{
		id:       id,
		packtype: SocketOpen,
	}

	for {
		n, err := conn.Read(buffer)
		if err != nil {
			break
		}
		if n == 0 {
			continue
		}

		p := Packet{
			id:       id,
			packtype: SocketData,
			buffer:   make([]byte, n),
		}
		copy(p.buffer, buffer[:n])
		packetChan <- p
	}

	packetChan <- Packet{
		id:       id,
		packtype: SocketClose,
	}
}
