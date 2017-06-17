.code32
.include "linux.s"
.include "record_def.s"

.section .data

.section .bss
.lcomm record_buffer, RECORD_SIZE

.section .text

# main program
.globl _start
_start:

# stack positions
.equ ST_FD, -4
.equ ST_ARGC, 0 	# Number of arguments
.equ ST_ARGV_0, 4 	# Name of program
.equ ST_ARGV_1, 8 	# Object filename

# copy the stack pointer to %ebp
movl %esp, %ebp
# allocate space to hold the file descriptor
subl $4, %esp

# open the file
movl $SYS_OPEN, %eax
movl ST_ARGV_1(%ebp), %ebx
movl $2, %ecx # read/write mode
movl $0666, %edx
int $LINUX_SYSCALL

# save file descriptor
movl %eax, ST_FD(%ebp)

loop_begin:
pushl ST_FD(%ebp)
pushl $record_buffer
call read_record
add $8, %esp

# returns the number of bytes read
# if it isn't the same number we requested, then it's either an end_of_file or 
# and error, so we're quitting
cmpl $RECORD_SIZE, %eax
jne loop_end

# increment age
incl record_buffer + RECORD_AGE

# move the write pointer
movl $SYS_LSEEK, %eax
movl ST_FD(%ebp), %ebx
movl $-RECORD_SIZE, %ecx
movl $1, %edx # SEEK_CUR
int $LINUX_SYSCALL

# error occured
cmpl $0, %eax
jl error_end

# write back
pushl ST_FD(%ebp)
pushl $record_buffer
call write_record
addl $8, %esp

jmp loop_begin

loop_end:
movl $SYS_EXIT, %eax
movl $0, %ebx
int $LINUX_SYSCALL

error_end:
movl $SYS_EXIT, %eax
movl $1, %ebx
int $LINUX_SYSCALL
