# bundle all
all: exit maximum

exit: exit.s
	as exit.s -o exit.o
	ld exit.o -o exit

maximum: maximum.s
	as maximum.s -o maximum.o
	ld maximum.o -o maximum

# clean auto generate file
clean:
	rm -f exit.o
	rm -f exit
	rm -f maximum.o
	rm -f maximum
