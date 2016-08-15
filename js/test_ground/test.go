package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
)

func main() {
	json_blob, err := ioutil.ReadFile("test.json")
	fmt.Println(string(json_blob))
	if err != nil {
		log.Fatal(err)
	}

	type Temp struct {
		Airline string `json: "airline"`
		Number  int    `json: "number"`
	}

	var t Temp

	err = json.Unmarshal(json_blob, &t)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("%+v", t)
}
