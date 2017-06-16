.code32
# Write a newline to fd
.include "linux.s"

.section .data
newline:
.ascii "\n"

.section .text

# stack positions
.equ ST_FD, 8

.globl write_newline
.type write_newline, @function
write_newline:

pushl %ebp
movl %esp, %ebp

movl $SYS_WRITE, %eax
movl ST_FD(%esp), %ebx
movl $newline, %ecx
movl $1, %edx
int $LINUX_SYSCALL

movl %ebp, %esp
popl %ebp
ret
