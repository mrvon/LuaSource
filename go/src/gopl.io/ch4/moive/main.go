package main

import (
	"encoding/json"
	"fmt"
	"log"
)

type Moive struct {
	Title  string
	Year   int  `json:"released"`
	Color  bool `json:"color,omitempty"`
	Actors []string
}

var moives = []Moive{
	{Title: "Casablanca", Year: 1942, Color: false,
		Actors: []string{"Humphrey Bogart", "Ingrid Bergman"}},
	{Title: "Cool Hand Luke", Year: 1967, Color: true,
		Actors: []string{"Paul Newman"}},
	{Title: "Bullitt", Year: 1968, Color: true,
		Actors: []string{"Steve McQueen", "Jacqueline Bisset"}},
}

func main() {
	{
		data, err := json.Marshal(moives)
		if err != nil {
			log.Fatalf("JSON marshaling failed: %s", err)
		}

		fmt.Printf("%s\n", data)

		var origin []Moive
		json.Unmarshal(data, &origin)

		fmt.Printf("%v\n", origin)
		fmt.Printf("%v\n", moives)
	}

	{
		data, err := json.MarshalIndent(moives, "", "    ")
		if err != nil {
			log.Fatalf("JSON marshaling failed: %s", err)
		}

		fmt.Printf("%s\n", data)
	}
}
