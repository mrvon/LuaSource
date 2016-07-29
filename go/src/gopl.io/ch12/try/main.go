package main

import (
	"bytes"
	"fmt"
	"io"
	"os"
	"reflect"
)

func main() {
	{
		s := "Hello"

		t := reflect.TypeOf(s)
		v := reflect.ValueOf(s)

		fmt.Println(t.String())
		fmt.Println(v.String())

		fmt.Println("Kind Enum", int(t.Kind()))
		fmt.Println("Kind Enum", int(v.Kind()))
		fmt.Println()
	}
	{
		i := 1

		t := reflect.TypeOf(i)
		v := reflect.ValueOf(i)

		fmt.Println(t.String())
		fmt.Println(v.String())
		fmt.Println(v.Int())

		fmt.Println("Kind Enum", int(t.Kind()))
		fmt.Println("Kind Enum", int(v.Kind()))
		fmt.Println()
	}
	{
		f := 3.14

		t := reflect.TypeOf(f)
		v := reflect.ValueOf(f)

		fmt.Println(t.String())
		fmt.Println(v.String())
		fmt.Println(v.Float())

		fmt.Println("Kind Enum", int(t.Kind()))
		fmt.Println("Kind Enum", int(v.Kind()))
		fmt.Println()
	}
	{
		var w io.Writer = new(bytes.Buffer)

		t := reflect.TypeOf(w)
		v := reflect.ValueOf(w)

		fmt.Println(t.String())
		fmt.Println(v.String())

		fmt.Println("Kind Enum", int(t.Kind()))
		fmt.Println("Kind Enum", int(v.Kind()))
		fmt.Println()
	}
	{
		var w io.Writer = os.Stdout

		t := reflect.TypeOf(w)
		v := reflect.ValueOf(w)

		fmt.Println(t.String())
		fmt.Println(v.String())

		fmt.Println("Kind Enum", int(t.Kind()))
		fmt.Println("Kind Enum", int(v.Kind()))
		fmt.Println()
	}
	{
		type MyStruct struct {
			s string
			i int
		}

		u := MyStruct{
			"Hello",
			1024,
		}

		t := reflect.TypeOf(u)
		v := reflect.ValueOf(u)

		fmt.Println(t.String())
		fmt.Println(v.String())

		fmt.Println("Kind Enum", int(t.Kind()))
		fmt.Println("Kind Enum", int(v.Kind()))

		x := v.Interface()
		u2 := x.(MyStruct)
		fmt.Println(u2.s, u2.i)

		fmt.Println()
	}

	// fmt.Println(int(reflect.Invalid))
	// fmt.Println(int(reflect.Bool))
	// fmt.Println(int(reflect.Int))
}
