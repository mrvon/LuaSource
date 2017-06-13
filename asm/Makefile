# bundle all
all: exit

exit: exit.s
	as exit.s -o exit.o
	ld exit.o -o exit

# clean auto generate file
clean:
	rm -f exit.o
	rm -f exit
