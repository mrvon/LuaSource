package main

import (
	"fmt"
	"image/png"
	"io/ioutil"
	"math"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
)

func max(x int, y int) int {
	if x >= y {
		return x
	} else {
		return y
	}
}

func calc_range(x int) int {
	r := 256
	for x > r {
		r *= 2
	}
	return r
}

type Item struct {
	filename string
	height   int
	width    int
}

type ItemList []Item

func (v ItemList) Len() int {
	return len(v)
}

func (v ItemList) Less(i int, j int) bool {
	di := max(v[i].height, v[i].width)
	dj := max(v[j].height, v[j].width)
	return di <= dj
}

func (v ItemList) Swap(i int, j int) {
	v[i], v[j] = v[j], v[i]
}

func filterDir(dir string) bool {
	if dir == ".git" || dir == ".svn" {
		return true
	} else {
		return false
	}
}

var type_matcher = regexp.MustCompile(`.[pP][nN][gG]$`)

func filterType(file string) bool {
	return type_matcher.MatchString(file)
}

func walkDir(dir string, callback func(filelist []string)) {
	var filelist []string
	for _, entry := range dirents(dir) {
		if entry.IsDir() {
			if filterDir(entry.Name()) {
				continue
			}
			subDir := filepath.Join(dir, entry.Name())
			walkDir(subDir, callback)
		} else {
			filename := filepath.Join(dir, entry.Name())

			if !filterType(filename) {
				continue
			}

			filelist = append(filelist, filename)
		}
	}
	callback(filelist)
}

func dirents(dir string) []os.FileInfo {
	entries, err := ioutil.ReadDir(dir)
	if err != nil {
		return nil
	}
	return entries
}

func runcmd(c string) {
	cmd := exec.Command("cmd", "/C", c)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	err := cmd.Run()
	if err != nil {
		fmt.Println("ERROR:", err)
	}
}

type AlgoFunc func(int, ItemList) int

var ALGO_MAP map[int]AlgoFunc

var INPUT_DIR string
var TEMP_DIR string
var OUTPUT_PLIST string
var OUTPUT_PNG string

func main() {
	INPUT_DIR = os.Args[1]
	TEMP_DIR = os.Args[2]
	OUTPUT_PLIST = os.Args[3]
	OUTPUT_PNG = os.Args[4]

	ALGO_MAP = make(map[int]AlgoFunc)

	ALGO_MAP[11] = try_algo_alpha1
	ALGO_MAP[12] = try_algo_alpha2

	ALGO_MAP[1] = try_algo_beta1
	ALGO_MAP[2] = try_algo_beta2
	ALGO_MAP[3] = try_algo_beta3
	ALGO_MAP[4] = try_algo_beta4
	ALGO_MAP[5] = try_algo_beta5

	walkDir(INPUT_DIR, func(filelist []string) {
		item_list := ItemList{}
		for i := 0; i < len(filelist); i++ {
			filename := filelist[i]

			f, err := os.Open(filename)
			if err != nil {
				continue
			}

			data, err := ioutil.ReadAll(f)
			if err != nil {
				continue
			}

			reader := strings.NewReader(string(data))
			conf, err := png.DecodeConfig(reader)
			if err != nil {
				fmt.Printf("%s is not a png.\n", filename)
				continue
			}

			item_list = append(item_list, Item{
				filename: filename,
				height:   conf.Height,
				width:    conf.Width,
			})

			f.Close()
		}

		sort.Sort(item_list)

		try_driver(item_list)
	})
}

func calc_size(filename string) int {
	size := 0

	f, err := os.Open(filename)
	if err != nil {
		return size
	}

	data, err := ioutil.ReadAll(f)
	if err != nil {
		return size
	}

	reader := strings.NewReader(string(data))
	conf, err := png.DecodeConfig(reader)
	if err != nil {
		fmt.Printf("%s is not a png.\n", filename)
		return size
	}

	size += (conf.Height * conf.Width)

	f.Close()
	return size
}

func try_driver(item_list ItemList) {
	ms := math.MaxInt32
	ma := 0

	result := make(map[int]int)

	for algo, f := range ALGO_MAP {
		s := f(algo, item_list)
		result[algo] = s
		if s < ms {
			ma = algo
			ms = s
		} else if s == ms && algo < ma {
			ma = algo
			ms = s
		}
	}

	for algo, size := range result {
		fmt.Printf("\n-------------------------------- ALGO: %d PIXEL: %d \n", algo, size)
	}
	fmt.Printf("\nMIN ---------------------------- ALGO: %d PIXEL: %d \n", ma, ms)
}

func try_algo_alpha1(algo int, item_list ItemList) int {
	return __try_algo_alpha(algo, 2000*2048, item_list)
}

func try_algo_alpha2(algo int, item_list ItemList) int {
	return __try_algo_alpha(algo, 1000*1024, item_list)
}

func __try_algo_alpha(algo int, size_limit int, item_list ItemList) int {
	total_size := 0
	output_id := 0

	for len(item_list) > 0 {
		splice_list := ItemList{}

		item := item_list[0]
		item_list = item_list[1:]
		splice_list = append(splice_list, item)
		total_pixel := (item.height * item.width)

		max_range := calc_range(max(item.height, item.width))

		for len(item_list) > 0 {
			item := item_list[0]
			if item.height > max_range || item.width > max_range || total_pixel > size_limit {
				break
			}

			total_pixel += (item.height * item.width)
			item_list = item_list[1:]
			splice_list = append(splice_list, item)
		}

		runcmd(fmt.Sprintf("IF EXIST %s RD /s /Q %s", TEMP_DIR, TEMP_DIR))
		runcmd(fmt.Sprintf("MD %s", TEMP_DIR))

		for i := 0; i < len(splice_list); i++ {
			item := splice_list[i]
			runcmd(fmt.Sprintf("COPY %s %s", item.filename, TEMP_DIR))
		}

		packer_cmd := fmt.Sprintf(`TexturePacker.exe --data %s --format cocos2d --dpi 72 --max-size 2048 --force-squared --size-constraints POT --algorithm MaxRects --sheet %s %s`,
			fmt.Sprintf(OUTPUT_PLIST, algo, output_id),
			fmt.Sprintf(OUTPUT_PNG, algo, output_id),
			TEMP_DIR)

		runcmd(packer_cmd)

		total_size += calc_size(fmt.Sprintf(OUTPUT_PNG, algo, output_id))

		output_id++
	}

	return total_size
}

func try_algo_beta1(algo int, item_list ItemList) int {
	return __try_algo_beta(algo, item_list, 0)
}

func try_algo_beta2(algo int, item_list ItemList) int {
	list1 := ItemList{}
	list2 := ItemList{}
	flag := false
	for {
		if len(item_list) > 0 {
			item := item_list[0]
			item_list = item_list[1:]
			if flag {
				list1 = append(list1, item)
			} else {
				list2 = append(list2, item)
			}
		} else {
			break
		}

		if len(item_list) > 0 {
			item := item_list[0]
			item_list = item_list[1:]
			if !flag {
				list1 = append(list1, item)
			} else {
				list2 = append(list2, item)
			}
		} else {
			break
		}

		flag = !flag
	}
	return __try_algo_beta(algo, list1, 0) +
		__try_algo_beta(algo, list2, 1)
}

func try_algo_beta3(algo int, item_list ItemList) int {
	list1 := ItemList{}
	list2 := ItemList{}
	list3 := ItemList{}
	flag := 0
	for {
		if len(item_list) > 0 {
			item := item_list[0]
			item_list = item_list[1:]
			if flag == 0 {
				list1 = append(list1, item)
			} else if flag == 1 {
				list2 = append(list2, item)
			} else {
				list3 = append(list3, item)
			}
		} else {
			break
		}

		if len(item_list) > 0 {
			item := item_list[0]
			item_list = item_list[1:]
			if flag == 0 {
				list1 = append(list1, item)
			} else if flag == 1 {
				list2 = append(list2, item)
			} else {
				list3 = append(list3, item)
			}
		} else {
			break
		}

		if flag == 0 {
			flag = 1
		} else if flag == 1 {
			flag = 2
		} else {
			flag = 0
		}
	}

	return __try_algo_beta(algo, list1, 0) +
		__try_algo_beta(algo, list2, 1) +
		__try_algo_beta(algo, list3, 2)
}

func try_algo_beta4(algo int, item_list ItemList) int {
	s1 := len(item_list) / 4
	s2 := s1 + len(item_list)/2
	head := item_list[:s1]
	tail := item_list[s2:]
	list1 := item_list[s1:s2]
	list2 := make(ItemList, len(head)+len(tail))
	c := copy(list2, head)
	copy(list2[c:], tail)
	return __try_algo_beta(algo, list1, 0) +
		__try_algo_beta(algo, list2, 1)
}

func try_algo_beta5(algo int, item_list ItemList) int {
	l := len(item_list) / 4
	s1 := l
	s2 := s1 + l
	s3 := s2 + l
	return __try_algo_beta(algo, item_list[:s1], 0) +
		__try_algo_beta(algo, item_list[s1:s2], 1) +
		__try_algo_beta(algo, item_list[s2:s3], 2) +
		__try_algo_beta(algo, item_list[s3:], 3)
}

func __try_algo_beta(algo int, item_list ItemList, output_id int) int {
	total_size := 0

	runcmd(fmt.Sprintf("IF EXIST %s RD /s /Q %s", TEMP_DIR, TEMP_DIR))
	runcmd(fmt.Sprintf("MD %s", TEMP_DIR))

	for i := 0; i < len(item_list); i++ {
		item := item_list[i]
		runcmd(fmt.Sprintf("COPY %s %s", item.filename, TEMP_DIR))
	}

	packer_cmd := fmt.Sprintf(`TexturePacker.exe --data %s --format cocos2d --dpi 72 --force-squared --size-constraints POT --algorithm MaxRects --sheet %s %s`,
		fmt.Sprintf(OUTPUT_PLIST, algo, output_id),
		fmt.Sprintf(OUTPUT_PNG, algo, output_id),
		TEMP_DIR)

	runcmd(packer_cmd)

	total_size += calc_size(fmt.Sprintf(OUTPUT_PNG, algo, output_id))

	return total_size
}
