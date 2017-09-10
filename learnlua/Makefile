CC = gcc

# bundle all
all:                   \
	stack_dump 		   \
	simple_interpreter \
	read_conf 	   	   \
	simple_lib		\
	zlib		\

clean:
	rm -f stack_dump.o
	rm -f simple_interpreter
	rm -f read_conf
	rm -f simple_lib.so
	rm -f zlib.so

stack_dump: stack_dump.c
	$(CC) -c stack_dump.c -o stack_dump.o

simple_interpreter: simple_interpreter.c
	$(CC) -o $@ simple_interpreter.c -llua

read_conf: read_conf.c stack_dump
	$(CC) -o $@ read_conf.c stack_dump.o -llua

simple_lib: simple_lib.c
	$(CC) -o simple_lib.so -llua -ldl

zlib: zlib.c
	$(CC) -o zlib.so -llua -ldl
