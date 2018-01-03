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

var addr = flag.String("addr", "localhost:8001", "http service address")

var upgrader = websocket.Upgrader{} // use default options

func home(w http.ResponseWriter, r *http.Request) {
	c, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Print("upgrade:", err)
		return
	}
	defer c.Close()
	s, err := net.Dial("tcp", "localhost:8888")
	if err != nil {
		log.Print("connect to server:", err)
		return
	}
	// block mode
	s.SetDeadline(time.Time{})
	defer s.Close()
	// read from frontend, write to backend
	go func() {
		for {
			message_type, message, err := c.ReadMessage()
			if err != nil {
				log.Println("read:", err)
				return
			}
			if message_type == websocket.BinaryMessage {
				var size uint16 = uint16(len(message))
				buf := new(bytes.Buffer)
				binary.Write(buf, binary.BigEndian, size)
				s.Write(buf.Bytes())
				s.Write(message)
			}
		}
	}()
	// read from backend, write to frontend
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
			return
		}
	}
}

func main() {
	flag.Parse()
	log.SetFlags(0)
	http.HandleFunc("/", home)
	log.Fatal(http.ListenAndServe(*addr, nil))
}
