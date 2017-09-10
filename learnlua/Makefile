CC = gcc

# bundle all
all:                   \
	stack_dump         \
	simple_interpreter \
	simple_stack	   \
	read_conf          \
	simple_lib         \
	zlib               \

clean:
	rm -f read_conf
	rm -f stack_dump.o
	rm -f simple_interpreter
	rm -f simple_stack
	rm -f simple_lib.so
	rm -f zlib.so

stack_dump: stack_dump.c
	$(CC) -c stack_dump.c -o stack_dump.o

simple_interpreter: simple_interpreter.c
	$(CC) -o $@ simple_interpreter.c -llua

read_conf: read_conf.c stack_dump
	$(CC) -o $@ read_conf.c stack_dump.o -llua

simple_stack: simple_stack.c stack_dump
	$(CC) -o $@ simple_stack.c stack_dump.o -llua

simple_lib: simple_lib.c
	$(CC) -fPIC --shared -o simple_lib.so simple_lib.c -llua

zlib: zlib.c
	$(CC) -fPIC --shared -o zlib.so zlib.c -llua -lz
