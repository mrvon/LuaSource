#
# Makefile for TINY
# Borland C Version
# K. Louden 2/3/1998
#
# GCC Version
# Mrvon 9/21/2016
#

CC = gcc

CFLAGS = 

OBJS = main.o util.o scan.o parse.o symtab.o analyze.o code.o cgen.o

all: tiny tm

tiny: $(OBJS)
	$(CC) -o $@ $(CFLAGS) $(OBJS)

tm: tm.c
	$(CC) -o $@ $(CFLAGS) tm.c

clean:
	rm tiny
	rm tm
	rm main.o
	rm util.o
	rm scan.o
	rm parse.o
	rm symtab.o
	rm analyze.o
	rm code.o
	rm cgen.o

main.o: main.c globals.h util.h scan.h parse.h analyze.h cgen.h
	$(CC) $(CFLAGS) -c main.c

util.o: util.c util.h globals.h
	$(CC) $(CFLAGS) -c util.c

scan.o: scan.c scan.h util.h globals.h
	$(CC) $(CFLAGS) -c scan.c

parse.o: parse.c parse.h scan.h globals.h util.h
	$(CC) $(CFLAGS) -c parse.c

symtab.o: symtab.c symtab.h
	$(CC) $(CFLAGS) -c symtab.c

analyze.o: analyze.c globals.h symtab.h analyze.h
	$(CC) $(CFLAGS) -c analyze.c

code.o: code.c code.h globals.h
	$(CC) $(CFLAGS) -c code.c

cgen.o: cgen.c globals.h symtab.h code.h cgen.h
	$(CC) $(CFLAGS) -c cgen.c
