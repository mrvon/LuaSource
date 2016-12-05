package main

func isValidSudoku(board [][]byte) bool {
	if len(board) != 9 {
		return false
	}

	if len(board[0]) != 9 {
		return false
	}

	// scan line to line
	for i := 0; i < 9; i++ {
		m := make(map[byte]bool)
		for j := 0; j < 9; j++ {
			c := board[i][j]
			if c != '.' {
				if m[c] {
					return false
				} else {
					m[c] = true
				}
			}
		}
	}

	// scan column to column
	for j := 0; j < 9; j++ {
		m := make(map[byte]bool)
		for i := 0; i < 9; i++ {
			c := board[i][j]
			if c != '.' {
				if m[c] {
					return false
				} else {
					m[c] = true
				}
			}
		}
	}

	// scan in the box
	pivots := [][]int{
		{0, 0},
		{0, 3},
		{0, 6},
		{3, 0},
		{3, 3},
		{3, 6},
		{6, 0},
		{6, 3},
		{6, 6},
	}

	for k := 0; k < len(pivots); k++ {
		m := make(map[byte]bool)
		x := pivots[k][0]
		y := pivots[k][1]
		for i := x; i < 3+x; i++ {
			for j := y; j < 3+y; j++ {
				c := board[i][j]
				if c != '.' {
					if m[c] {
						return false
					} else {
						m[c] = true
					}
				}
			}
		}
	}

	return true
}
