package main

import (
	"fmt"
	"reflect"
	"strings"
	"unsafe"
)

func main() {
	var x struct {
		a bool
		b int16
		c []int
	}

	fmt.Println(unsafe.Sizeof(x))
	fmt.Println(unsafe.Sizeof(x.a))
	fmt.Println(unsafe.Sizeof(x.b))
	fmt.Println(unsafe.Sizeof(x.c))

	fmt.Println(unsafe.Alignof(x))
	fmt.Println(unsafe.Alignof(x.a))
	fmt.Println(unsafe.Alignof(x.b))
	fmt.Println(unsafe.Alignof(x.c))

	fmt.Println(unsafe.Offsetof(x.a))
	fmt.Println(unsafe.Offsetof(x.b))
	fmt.Println(unsafe.Offsetof(x.c))

	fmt.Printf("%#016x\n", Float64bits(1.0))

	///////////////////////////////////////

	got := strings.Split("a:b:c", ":")
	want := []string{"a", "b", "c"}
	fmt.Println(reflect.DeepEqual(got, want))

	var a, b []string = nil, []string{}
	fmt.Println(reflect.DeepEqual(a, b))

	var c, d map[string]int = nil, make(map[string]int)
	fmt.Println(reflect.DeepEqual(c, d))
}

func Float64bits(f float64) uint64 {
	return *(*uint64)(unsafe.Pointer(&f))
}
