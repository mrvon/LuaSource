// Websocket Proxy

package main

import (
	"bytes"
	"flag"
	"log"
	"net"
	"net/http"
	"time"

	"encoding/binary"

	"github.com/gorilla/websocket"
)

const (
	frontend = "8001"
	backend  = "8888"
)

var addr = flag.String("addr", "localhost:"+frontend, "http service address")

var upgrader = websocket.Upgrader{} // use default options

func home(w http.ResponseWriter, r *http.Request) {
	c, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Print("upgrade:", err)
		return
	}
	defer c.Close()
	log.Print(c.RemoteAddr(), " new client connected")
	s, err := net.Dial("tcp", "localhost:"+backend)
	if err != nil {
		log.Print(c.RemoteAddr(), "connect to backend:", err)
		return
	}
	// block mode
	s.SetDeadline(time.Time{})
	defer s.Close()
	finish := make(chan bool)
	// read from frontend, write to backend
	go func() {
		for {
			message_type, message, err := c.ReadMessage()
			if err != nil {
				log.Println(c.RemoteAddr(), "read message:", err)
				break
			}
			if message_type == websocket.BinaryMessage {
				var size uint16 = uint16(len(message))
				buf := new(bytes.Buffer)
				binary.Write(buf, binary.BigEndian, size)
				s.Write(buf.Bytes())
				s.Write(message)
			} else if message_type == websocket.CloseMessage {
				break
			} else {
				// ignore message
			}
		}
		finish <- true
	}()
	// read from backend, write to frontend
	go func() {
		for {
			header := make([]byte, 2)
			s.Read(header)
			buf := new(bytes.Buffer)
			buf.Write(header)
			var size int16
			binary.Read(buf, binary.BigEndian, &size)
			body := make([]byte, size)
			s.Read(body)
			err = c.WriteMessage(websocket.BinaryMessage, body)
			if err != nil {
				log.Println("write:", err)
				break
			}
		}
		finish <- true
	}()
	// main goroutine wait
	<-finish
}

func main() {
	flag.Parse()
	log.SetFlags(0)
	http.HandleFunc("/", home)
	log.Fatal(http.ListenAndServe(*addr, nil))
}
