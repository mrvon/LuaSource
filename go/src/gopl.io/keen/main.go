package main

import (
	"fmt"
	"keen/gate"
)

func main() {
	packetChan := make(chan gate.Packet)

	gate.Start(packetChan)

	for packet := range packetChan {
		fmt.Printf("%#v\n", packet)
	}
}
