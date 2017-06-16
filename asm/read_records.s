.code32
.include "linux.s"
.include "record_def.s"

.section .data
file_name:
.ascii "test.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

.section .text

# main program
.globl _start
_start:

# there are the locations on the stack where we will store the input and output
# descriptors (FYI - we could have used memory addresses in a .data section
# instead)
.equ ST_IN_FD, -4
.equ ST_OUT_FD, -8

# copy the stack pointer to %ebp
movl %esp, %ebp
# allocate space to hold the file descriptors
subl $8, %esp

# open the file
movl $SYS_OPEN, %eax
movl $file_name, %ebx
movl $0, %ecx # this says to open read-only
movl $0666, %edx
int $LINUX_SYSCALL

#save file descriptor
movl %eax, ST_IN_FD(%ebp)

# even though it's a constant, we are saving the output file descriptor in a
# local variable so that if we later decide that it isn't always going to be 
# STDOUT, we can change it easily.
movl $STDOUT, ST_OUT_FD(%ebp)

record_read_loop:
pushl ST_IN_FD(%ebp)
pushl $record_buffer
call read_record
add $8, %esp

# returns the number of bytes read. if it isn't the same number we requested,
# them it's either an end_of_file, or an error, so we're quitting
cmpl $RECORD_SIZE, %eax
jne finished_reading

# otherwise, print out the first name but first, we must know it's size
pushl $RECORD_FIRSTNAME + record_buffer
call count_chars
addl $4, %esp

movl %eax, %edx
movl $SYS_WRITE, %eax
movl ST_OUT_FD(%ebp), %ebx
movl $RECORD_FIRSTNAME + record_buffer, %ecx
int $LINUX_SYSCALL

pushl ST_OUT_FD(%ebp)
call write_newline
addl $4, %esp

jmp record_read_loop

finished_reading:
movl $SYS_EXIT, %eax
movl $0, %ebx
int $LINUX_SYSCALL
