.code32
# PURPOSE: 
#
# Simple program that exits and returns a status code back to the Linux kernel

# INPUT:
#
# none

# OUTPUT:
#
# returns a status code. This can be viewed by typing echo $? after running
# the program

# VARIABLES:
#
# %eax holds the system call number
# %ebx holds the return status

.section .data

.section .text
.globl _start
_start:
# this is the linux kernel command number (system call) for exiting a program
movl $1, %eax
# this is the status number we will return to the operating system.
# change this around and it will return different things to echo $?
movl $0, %ebx
# this wakes up the kernal to run the exit command
int $0x80
