package bzip_test

import (
	"bytes"
	"compress/bzip2" // reader
	"io"
	"testing"

	"gopl.io/ch13/bzip" // writer
)

func TestBzip2(t *testing.T) {
	var compressed, uncompressed bytes.Buffer

	w := bzip.NewWriter(&compressed)

	// Write a repetitive message in a million pieces,
	// compressing one copy(compressed) but not the other(uncompressed).
	tee := io.MultiWriter(w, &uncompressed)
	for i := 0; i < 1000000; i++ {
		io.WriteString(tee, "hello")
	}

	if err := w.Close(); err != nil {
		t.Fatal(err)
	}

	// Check the size of the compressed stream.
	if got, want := compressed.Len(), 255; got != want {
		t.Errorf("1 million hellos compressed to %dbytes, want %d", got, want)
	}

	// Decompress and compare with original.
	var decompressed bytes.Buffer
	io.Copy(&decompressed, bzip2.NewReader(&compressed))
	if !bytes.Equal(uncompressed.Bytes(), decompressed.Bytes()) {
		t.Error("decompressed yielded a different message")
	}
}
