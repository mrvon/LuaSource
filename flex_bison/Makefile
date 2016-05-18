# Your platform
PLATFORM= none

# bundle all
all: wc calc

# unix wc
wc: wc.l
	flex -o wc.c wc.l
	cc -o $@ wc.c

# calculator
calc: calc.l calc.y
	yacc -d -o calc_parser.c calc.y
	flex -o calc_lexer.c calc.l
	cc -o $@ calc_lexer.c calc_parser.c

# clean auto generate file
clean:
	rm -f wc.c
	rm -f calc_lexer.c calc_parser.h calc_parser.c

cleanall: clean
	rm -f wc
	rm -f calc
