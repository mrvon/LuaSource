CC 		= gcc
CPPC  	= g++

# bundle all
all: \
	rb_tree \
	skip_list \
	quick_sort \
	quick_sort_with_stack \
	link_list \
	rename \
	dangling_else \
	alignment \
	alloc \
	complement \
	unsigned_char \
	setjmp \
	setjmp_link \
	strsep \
	use_readline \
	offsetof \
	float \

clean:

rb_tree: rb_tree.c
	$(CC) -o $@ rb_tree.c

skip_list: skip_list.c
	$(CC) -o $@ skip_list.c

link_list: link_list.c
	$(CC) -o $@ link_list.c

quick_sort: quick_sort.c
	$(CC) -o $@ quick_sort.c

quick_sort_with_stack: quick_sort_with_stack.cc
	$(CPPC) -o $@ quick_sort_with_stack.cc

rename: rename.c
	$(CC) -o $@ rename.c

dangling_else: dangling_else.c
	$(CC) -o $@ dangling_else.c

alignment: alignment.c
	$(CC) -o $@ alignment.c

alloc: alloc.c
	$(CC) -o $@ alloc.c

complement: complement.c
	$(CC) -o $@ complement.c

unsigned_char: unsigned_char.c
	$(CC) -o $@ unsigned_char.c

setjmp: setjmp.c
	$(CC) -o $@ setjmp.c

setjmp_link: setjmp_link.c
	$(CC) -o $@ setjmp_link.c

strsep: strsep.c
	$(CC) -o $@ strsep.c

use_readline: use_readline.c
	$(CC) -o $@ use_readline.c -lreadline 

offsetof: offsetof.c
	$(CC) -o $@ offsetof.c

float: float.c
	$(CC) -o $@ float.c
