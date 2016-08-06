package main

import (
	"fmt"
	"io"
	"log"
	"net"
	"os"
	"strings"
	"time"
)

func main() {
	for _, arg := range os.Args[1:] {
		res := strings.Split(arg, "=")

		if len(res) != 2 {
			continue
		}

		// name := res[0]
		host := res[1]

		fmt.Println(host)

		conn, err := net.Dial("tcp", host)
		if err != nil {
			log.Fatal(err)
		}

		defer conn.Close()
		go mustCopy(os.Stdout, conn)
	}
	time.Sleep(time.Hour)
}

func mustCopy(dst io.Writer, src io.Reader) {
	if _, err := io.Copy(dst, src); err != nil {
		log.Fatal(err)
	}
}
