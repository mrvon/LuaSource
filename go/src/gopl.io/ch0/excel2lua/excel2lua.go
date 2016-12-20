package main

import (
	"bytes"
	"fmt"
	"strings"

	"github.com/tealeg/xlsx"
)

const (
	COMMENT = 0
	TYPE    = 1
	KEY     = 2
	VAL     = 3
)

var SPLIT = []string{
	",",
	";",
	"|",
}

func parse(filename string) {
	file, err := xlsx.OpenFile(filename)
	if err != nil {
		panic(err)
	}

	for _, sheet := range file.Sheets {
		var type_list []string
		var key_list []string

		buf := new(bytes.Buffer)
		buf.WriteString("return {\n")

		for row_id, row := range sheet.Rows {
			if row_id == COMMENT {
				// Just ignore
			} else if row_id == TYPE {
				for _, cell := range row.Cells {
					s, err := cell.String()
					if err != nil {
						panic(err)
					}
					type_list = append(type_list, s)
				}
			} else if row_id == KEY {
				for _, cell := range row.Cells {
					s, err := cell.String()
					if err != nil {
						panic(err)
					}
					key_list = append(key_list, s)
				}
			} else {
				buf.WriteString(fmt.Sprintf("%s[%d] = {\n", padding(1), row_id-VAL+1))
				parse_col(buf, row, type_list, key_list, 2)
				buf.WriteString(fmt.Sprintf("%s},\n", padding(1)))
			}
		}

		buf.WriteString("}")
		fmt.Printf("%s\n", buf.Bytes())
	}
}

func parse_col(buf *bytes.Buffer, row *xlsx.Row, type_list []string, key_list []string, nest_level int) {
	for col_id, cell := range row.Cells {
		parse_cell(buf, key_list[col_id], cell, type_list[col_id], nest_level)
	}
}

func parse_cell(buf *bytes.Buffer, key string, val *xlsx.Cell, val_type string, nest_level int) {
	if key == "" || val_type == "" {
		return
	}

	vt_list := strings.Split(val_type, "_")

	if len(vt_list) <= 1 {
		parse_atom(buf, key, val, val_type, nest_level)
	} else if len(vt_list) <= 4 {
		val_type = vt_list[0]
		s, err := val.String()
		if err != nil {
			panic(err)
		}

		buf.WriteString(fmt.Sprintf("%s[\"%s\"] = {\n", padding(nest_level), key))
		parse_list(buf, key, s, val_type, nest_level, len(vt_list)-1)
		buf.WriteString(fmt.Sprintf("%s},\n", padding(nest_level)))
	} else {
		panic("invalid list type")
	}
}

func parse_atom(buf *bytes.Buffer, key string, val *xlsx.Cell, val_type string, nest_level int) {
	if val_type == "string" {
		s, err := val.String()
		if err != nil {
			panic(err)
		}
		buf.WriteString(fmt.Sprintf("%s[\"%s\"] = \"%s\",\n", padding(nest_level), key, s))
	} else if val_type == "integer" {
		i, err := val.Int64()
		if err != nil {
			i = 0
		}
		buf.WriteString(fmt.Sprintf("%s[\"%s\"] = %d,\n", padding(nest_level), key, i))
	} else if val_type == "float" {
		f, err := val.Float()
		if err != nil {
			f = 0.0
		}
		buf.WriteString(fmt.Sprintf("%s[\"%s\"] = %f,\n", padding(nest_level), key, f))
	} else if val_type == "boolean" {
		b := val.Bool()
		buf.WriteString(fmt.Sprintf("%s[\"%s\"] = %v,\n", padding(nest_level), key, b))
	} else {
		panic("invalid atom type")
	}
}

func parse_list(buf *bytes.Buffer, key string, val string, val_type string, nest_level int, nest_list int) {
	val_list := strings.Split(val, SPLIT[nest_list-1])

	for i := 0; i < len(val_list); i++ {
		if nest_list > 1 {
			buf.WriteString(fmt.Sprintf("%s{\n", padding(nest_level+1)))
			parse_list(buf, key, val_list[i], val_type, nest_level+2, nest_list-1)
			buf.WriteString(fmt.Sprintf("%s},\n", padding(nest_level+1)))
		} else {
			// atom
			if val_type == "string" {
				buf.WriteString(fmt.Sprintf("%s\"%s\",\n", padding(nest_level), val_list[i]))
			} else {
				buf.WriteString(fmt.Sprintf("%s%s,\n", padding(nest_level), val_list[i]))
			}
		}
	}
}

func padding(nest_level int) string {
	var pad []byte
	indent := []byte("    ")
	for i := 0; i < nest_level; i++ {
		pad = append(pad, indent...)
	}
	return string(pad)
}

func main() {
	parse("/home/dennis/test.xlsx")
}
