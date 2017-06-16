.code32
# PURPOSE
#
# This program converts STDIN to STDOUT with all letters
# converted to uppercase.

.section .data

# CONSTANT

# system call numbers
.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

# standard file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# system call interrupt
.equ LINUX_SYSCALL, 0x80

# this is the return value of read which means we're hit the end of the file
.equ END_OF_FILE, 0

.section .bss
# Buffer - this is where the data is loaded into from the data file and written
# from into the output file. this should never exceed 16,000 for various reasons
.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

# stack positions
.equ ST_ARGC, 8 	# Number of arguments
.equ ST_ARGV_0, 12 	# Name of program
.equ ST_ARGV_1, 16 	# Input file name
.equ ST_ARGV_2, 20  # Output file name

.globl _start
_start:

# save the stack point
movl %esp, %ebp

# Begin main loop
read_loop_begin:

# read in a block from the input file
movl $SYS_READ, %eax
# get the input file descriptor
movl $STDIN, %ebx
# the location to read into
movl $BUFFER_DATA, %ecx
# the size of the buffer
movl $BUFFER_SIZE, %edx
# size of buffer read is returned in %eax
int $LINUX_SYSCALL

# Exit if we've reached the end
# check for end of file marker
cmpl $END_OF_FILE, %eax
# if found or on error, go to the end
jle end_loop

continue_read_loop:
# convert the block to uppercase
pushl $BUFFER_DATA    # location of buffer
pushl %eax            # size of the buffer
call convert_to_upper
popl %eax             # get the size back
addl $4, %esp         # restore %esp

# Write the block out to the output file
# size of the buffer
movl %eax, %edx
movl $SYS_WRITE, %eax
# file to use
movl $STDOUT, %ebx
# location of the buffer
movl $BUFFER_DATA, %ecx
int $LINUX_SYSCALL

# continue the loop
jmp read_loop_begin

end_loop:

# exit
movl $SYS_EXIT, %eax
movl $0, %ebx
int $LINUX_SYSCALL


# PURPOSE
#
# This function actually does the conversion to uppper case for a block

# INPUT
#
# The first parameter is the location of the block of memory to convert
# The second parameter is the length of that buffer

# OUTPUT
#
# This function overwrites the current buffer with the upper-casified version

# VARIABLES:
#
# %eax - beginning of buffer
# %ebx - length of buffer
# %edi - current buffer offset
# %cl  - current byte being examined (first part of %ecx)

# CONSTANT
# the lower boundary of our search
.equ LOWERCASE_A, 'a'
# the upper boundary of our search
.equ LOWERCASA_Z, 'z'
# conversion between uppper and lower case
.equ UPPER_CONVERSION, 'A' - 'a'

# stack stuff
.equ ST_BUFFER_LEN, 8 	# length of buffer
.equ ST_BUFFER, 12 		# actual buffer

convert_to_upper:
pushl %ebp
movl %esp, %ebp

# set up variables
movl ST_BUFFER(%ebp), %eax
movl ST_BUFFER_LEN(%ebp), %ebx
movl $0, %edi

# if a buffer with zero length was given to us, just leave
cmpl $0, %ebx
jle end_convert_loop

convert_loop:
# get the current byte
movb (%eax, %edi, 1), %cl

# go to the next byte unless it is between
# 'a' and 'z'
cmpb $LOWERCASE_A, %cl
jl next_byte
cmpb $LOWERCASA_Z, %cl
jg next_byte

# otherwise convert the byte to uppercase
addb $UPPER_CONVERSION, %cl
# add store it back
movb %cl, (%eax, %edi, 1)

next_byte:
incl %edi 		# next byte
cmpl %edi, %ebx # continue unless we've reached the end
jne convert_loop

end_convert_loop:
# no return value, just leave
movl %ebp, %esp
popl %ebp
ret
