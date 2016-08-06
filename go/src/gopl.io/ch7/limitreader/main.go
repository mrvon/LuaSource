package main

import (
	"fmt"
	"io"
	"os"
)

type limitReader struct {
	reader io.Reader
	remain int64
}

func (r *limitReader) Read(p []byte) (n int, err error) {
	if r.remain <= 0 {
		return 0, io.EOF
	}

	sz := len(p)
	if int(r.remain) < sz {
		sz = int(r.remain)
	}

	sz, err = r.reader.Read(p[:sz])
	return sz, err
}

func LimitReader(r io.Reader, n int64) io.Reader {
	return &limitReader{
		r,
		n,
	}
}

func main() {
	var buf [16]byte

	r := LimitReader(os.Stdin, 8)

	n, err := r.Read(buf[:])
	if err != nil {
		fmt.Println("Err", err)
		return
	}

	fmt.Println(n, buf)
}
