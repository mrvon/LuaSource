package main

import (
	"fmt"
)

type Flags uint

const (
	FlagUp           Flags = 1 << iota // is up
	FlagBroadcast                      // supports broadcast access capability
	FlagLoopback                       // is a loopback interface
	FlagPointToPoint                   // belongs to a point-to-point link
	FlagMulticast                      // supports multicast access capability
)

const (
	_   = 1 << (10 * iota)
	KiB // 1 << 10
	MiB // 1 << 20
	GiB // 1 << 30
	TiB // 1 << 40
	PiB // 1 << 50
	EiB // 1 << 60
	ZiB // 1 << 70
	YiB // 1 << 80
)

func IsUp(v Flags) bool {
	return v&FlagUp == FlagUp
}

func TurnDown(v *Flags) {
	*v &^= FlagUp
}

func SetBroadcast(v *Flags) {
	*v |= FlagBroadcast
}

func IsCast(v Flags) bool {
	return v&(FlagBroadcast|FlagMulticast) != 0
}

func main() {
	// fmt.Printf("%b\n", FlagUp)
	// fmt.Printf("%b\n", FlagBroadcast)
	// fmt.Printf("%b\n", FlagLoopback)
	// fmt.Printf("%b\n", FlagPointToPoint)
	// fmt.Printf("%b\n", FlagMulticast)

	// fmt.Println(KiB)
	// fmt.Println(MiB)
	// fmt.Println(GiB)
	// fmt.Println(TiB)
	// fmt.Println(PiB)
	// fmt.Println(EiB)
	// fmt.Println(YiB / ZiB)

	var v Flags = FlagMulticast | FlagUp

	fmt.Printf("%b %t\n", v, IsUp(v))

	TurnDown(&v)

	fmt.Printf("%b %t\n", v, IsUp(v))

	SetBroadcast(&v)

	fmt.Printf("%b %t\n", v, IsUp(v))
	fmt.Printf("%b %t\n", v, IsCast(v))
}
