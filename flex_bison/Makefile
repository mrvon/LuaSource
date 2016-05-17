# calculator
calc: calc.l calc.y
	yacc -d -o calc_parser.c calc.y
	flex -o calc_lexer.c calc.l
	cc -o $@ calc_lexer.c calc_parser.c -lfl

clean:
	rm calc calc_lexer.c calc_parser.h calc_parser.c
