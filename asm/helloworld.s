# PURPOSE
#
# This program writes the message "hello world" and exits

.code32

.section .data

helloworld:
.ascii "hello world\n"
helloworld_end:

.equ helloworld_len, helloworld_end - helloworld

.section .text

.globl _start
_start:

pushl $helloworld
call printf

pushl $0
call exit
