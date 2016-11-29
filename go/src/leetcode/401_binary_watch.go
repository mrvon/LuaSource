package main

import "fmt"

func hour(num int) []string {
	var h = [][]string{
		{"0"},                      // hours contains 0 1's
		{"1", "2", "4", "8"},       // hours contains 1 1's
		{"3", "5", "6", "9", "10"}, // hours contains 2 1's
		{"7", "11"},                // hours contains 3 1's
	}
	return h[num]
}

func minute(num int) []string {
	var m = [][]string{
		{"00"}, // mins contains 0 1's
		{"01", "02", "04", "08", "16", "32"},                                                                                     // mins contains 1 1's
		{"03", "05", "06", "09", "10", "12", "17", "18", "20", "24", "33", "34", "36", "40", "48"},                               // mins contains 2 1's
		{"07", "11", "13", "14", "19", "21", "22", "25", "26", "28", "35", "37", "38", "41", "42", "44", "49", "50", "52", "56"}, // mins contains 3 1's
		{"15", "23", "27", "29", "30", "39", "43", "45", "46", "51", "53", "54", "57", "58"},                                     // mins contains 4 1's
		{"31", "47", "55", "59"},                                                                                                 // mins contains 5 1's
	}
	return m[num]
}

func readBinaryWatch(num int) []string {
	var res []string

	for i := 0; i <= num; i++ {
		j := num - i

		if i > 3 || j > 5 {
			continue
		}

		var ht []string = hour(i)
		var mt []string = minute(j)

		for _, h := range ht {
			for _, m := range mt {
				res = append(res, h+":"+m)
			}
		}
	}

	return res
}

func main() {
	fmt.Println(readBinaryWatch(8))
}
