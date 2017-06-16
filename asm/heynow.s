.code32
# PURPOSE
#
# This program write a string to a file
# Show to use bss section to store fd

.section .data
file_out:
.ascii "heynow.txt\0"
file_context:
.ascii "Hey diddle diddle!"
file_context_end:
.equ file_context_size, file_context_end - file_context

.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

.equ O_CREAT_WRONLY_TRUNC, 03101

# system call interrupt
.equ LINUX_SYSCALL, 0x80

.section .bss
.lcomm FD_OUT, 4

.section .text

.globl _start
_start:

open_files:
open_fd_out:
movl $SYS_OPEN, %eax
movl $file_out, %ebx
movl $O_CREAT_WRONLY_TRUNC, %ecx
movl $0666, %edx
int $LINUX_SYSCALL

store_fd_out:
movl $FD_OUT, %ebx
movl %eax, (%ebx)

# write to file
movl $SYS_WRITE, %eax
# file to use
movl $FD_OUT, %ebx
movl (%ebx), %ebx
# location of the buffer
movl $file_context, %ecx
# size of buffer
movl $file_context_size, %edx
int $LINUX_SYSCALL

# close the file
movl $SYS_CLOSE, %eax
movl $FD_OUT, %ebx
movl (%ebx), %ebx
int $LINUX_SYSCALL

# exit
movl $SYS_EXIT, %eax
movl $0, %ebx
int $LINUX_SYSCALL
