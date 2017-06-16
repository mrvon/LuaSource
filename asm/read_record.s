.code32

.include "linux.s"
.include "record_def.s"

# PURPOSE
#
# This function reads a record from the file descriptor

# INPUT
#
# The file descriptor and a buffer

# OUTPUT
#
# This function writes the data to buffer and returns a status code

# STACK LOCAL VARIABLES
.equ ST_READ_BUFFER, 8
.equ ST_FD, 12

.section .text

.globl read_record
.type read_record, @function
read_record:

pushl %ebp
movl %esp, %ebp

pushl %ebx

movl $SYS_READ, %eax
movl ST_FD(%ebp), %ebx
movl ST_READ_BUFFER(%ebp), %ecx
movl $RECORD_SIZE, %edx
int $LINUX_SYSCALL

# Note - %eax has return value, which we will give back to our calling program
popl %ebx

movl %ebp, %esp
popl %ebp
ret
