CC 		= gcc

# bundle all
all:                      \
	rb_tree               \
	skip_list             \
	quick_sort            \
	quick_sort_with_stack \
	link_list             \
	rename                \
	dangling_else         \
	alignment             \
	alloc                 \
	complement            \
	unsigned_char         \
	setjmp                \
	setjmp_link           \
	strsep                \
	use_readline          \
	offsetof              \
	float                 \
	use_zlib              \
	use_zlib_2            \
	trick_1               \

clean:
	rm -f rb_tree               
	rm -f skip_list             
	rm -f quick_sort            
	rm -f quick_sort_with_stack 
	rm -f link_list             
	rm -f rename                
	rm -f dangling_else         
	rm -f alignment             
	rm -f alloc                 
	rm -f complement            
	rm -f unsigned_char         
	rm -f setjmp                
	rm -f setjmp_link           
	rm -f strsep                
	rm -f use_readline          
	rm -f offsetof              
	rm -f float                 
	rm -f use_zlib              
	rm -f use_zlib_2            
	rm -f trick_1               

rb_tree: rb_tree.c
	$(CC) -o $@ rb_tree.c

skip_list: skip_list.c
	$(CC) -o $@ skip_list.c

link_list: link_list.c
	$(CC) -o $@ link_list.c

quick_sort: quick_sort.c
	$(CC) -o $@ quick_sort.c

quick_sort_with_stack: quick_sort_with_stack.c
	$(CC) -o $@ quick_sort_with_stack.c

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

use_zlib: use_zlib.c
	$(CC) -o $@ -std=gnu99 use_zlib.c -lz

use_zlib_2: use_zlib_2.c
	$(CC) -o $@ -std=gnu99 use_zlib_2.c -lz

trick_1: trick_1.c
	$(CC) -o $@ trick_1.c
