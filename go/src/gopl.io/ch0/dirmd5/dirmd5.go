package main

import (
	"crypto/md5"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
)

var output_map = make(map[string]string)

func filterDir(dir string) bool {
	if dir == ".git" || dir == ".svn" {
		return true
	} else {
		return false
	}
}

func walkDir(dir string) {
	for _, entry := range dirents(dir) {
		if entry.IsDir() {
			if filterDir(entry.Name()) {
				continue
			}
			subDir := filepath.Join(dir, entry.Name())
			walkDir(subDir)
		} else {
			filename := filepath.Join(dir, entry.Name())

			f, err := os.Open(filename)
			if err != nil {
				continue
			}

			data, err := ioutil.ReadAll(f)
			if err != nil {
				continue
			}

			file_str := fmt.Sprintf("%q", filename)
			md5_str := fmt.Sprintf("\"%x\"", md5.Sum(data))
			output_map[file_str] = md5_str

			f.Close()
		}
	}
}

func dirents(dir string) []os.FileInfo {
	entries, err := ioutil.ReadDir(dir)
	if err != nil {
		return nil
	}
	return entries
}

func main() {
	root_dir := "/home/dennis/skynet"
	md5_file := "/home/dennis/verfication.lua"

	walkDir(root_dir)

	f, err := os.Create(md5_file)
	if err != nil {
		log.Fatal(err)
		return
	}

	fmt.Fprint(f, "return {\n")

	for k, v := range output_map {
		fmt.Fprint(f, "\t[")
		fmt.Fprint(f, k)
		fmt.Fprint(f, "]")
		fmt.Fprint(f, " = ")
		fmt.Fprint(f, v)
		fmt.Fprint(f, ",\n")
	}

	fmt.Fprint(f, "}\n")
}
