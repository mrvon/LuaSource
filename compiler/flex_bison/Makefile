# Your platform
PLATFORM= none

# bundle all
all: wc calc line hex select

# unix wc
wc: wc.l
	flex -o wc.c wc.l
	cc -o $@ wc.c

# calculator
calc: calc.l calc.y
	yacc -d -o calc_parser.c calc.y
	flex -o calc_lexer.c calc.l
	cc -o $@ calc_lexer.c calc_parser.c

# line
line: line.l
	flex -o line.c line.l
	cc -o $@ line.c

# hex
hex: hex.l
	flex -o hex.c hex.l
	cc -o $@ hex.c

# select
select: select.l
	flex -o select.c select.l
	cc -o $@ select.c

# clean auto generate file
clean:
	rm -f wc.c
	rm -f calc_lexer.c calc_parser.h calc_parser.c
	rm -f line.c
	rm -f hex.c
	rm -f select.c

cleanall: clean
	rm -f wc
	rm -f calc
	rm -f line
	rm -f hex
	rm -f select
