.code32
# PURPOSE
#
# Given a number, this program computes the square.
.section .data

.section .text
.globl _start
# this is unneeded unless we want to share this function among other programs
.globl square

_start:
# The square takes one argument
pushl $5
call square
add $4, %esp
movl %eax, %ebx
# call the kernal's exit function
movl $1, %eax
int $0x80

# This is the actual function definition
.type square, @function
square:

# standard function stuff
# we have to restore %ebp to its prior state before returning
# so we have to push it
pushl %ebp
movl %esp, %ebp
# moves the first argument to %eax
movl 8(%ebp), %eax
# multiply itself
imull %eax, %eax
# standard function return stuff
# have to restore %ebp and %esp to where they were before the function started
# return to the function (this pops the return value, too)
movl %ebp, %esp
popl %ebp
ret
