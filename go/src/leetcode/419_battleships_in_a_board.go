package main

import "fmt"

func fill(copy_board [][]byte, i int, j int) {
	row := len(copy_board) - 1
	col := len(copy_board[0]) - 1

	r := i
	c := j

	for r < row {
		r++
		if copy_board[r][j] == 'X' {
			copy_board[r][j] = 'Y'
		} else {
			break
		}
	}

	for c < col {
		c++
		if copy_board[i][c] == 'X' {
			copy_board[i][c] = 'Y'
		} else {
			break
		}
	}
}

func countBattleships(board [][]byte) int {
	var copy_board [][]byte

	for i := 0; i < len(board); i++ {
		copy_board = append(copy_board, []byte{})
		for j := 0; j < len(board[i]); j++ {
			copy_board[i] = append(copy_board[i], board[i][j])
		}
	}

	count := 0

	for i := 0; i < len(copy_board); i++ {
		for j := 0; j < len(copy_board[i]); j++ {
			c := copy_board[i][j]

			if c == 'X' {
				fill(copy_board, i, j)
				count += 1
			}
		}
	}

	return count
}

func main() {
	c := 0

	c = countBattleships(
		[][]byte{
			[]byte("X..X"),
			[]byte("...X"),
			[]byte("...X"),
		})

	fmt.Println(c)

	c = countBattleships(
		[][]byte{
			[]byte("X..X"),
			[]byte(".X.X"),
			[]byte("...X"),
		})

	fmt.Println(c)

	c = countBattleships(
		[][]byte{
			[]byte("XXXX"),
			[]byte("...."),
			[]byte("XXXX"),
		})

	fmt.Println(c)
}
