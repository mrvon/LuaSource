package main

import (
	"log"
	"os"
	"os/exec"
)

func main() {
	cmd := exec.Command("bzip2")
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	err := cmd.Run()
	if err != nil {
		log.Fatal(err)
	}
}
