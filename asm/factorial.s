.code32
# PURPOSE
#
# Given a number, this program computes the factorial.

# This program show how to call function recursively.
.section .data

.section .text
.globl _start
# this is unneeded unless we want to share this function among other programs
.global factorial

_start:
# The factorial takes one argument
# the number we want a factorial of.
pushl $5
# run the factorial function
call factorial
# scrubs the parameter that was pushed on the stack
addl $4, %esp
# factorial returns the answer in %eax, but we want it in %ebx to send it as
# our exit status
movl %eax, %ebx
# call the kernal's exit function
movl $1, %eax
int $0x80

# This is the actual function definition
.type factorial, @function
factorial:

# standard function stuff
# we have to restore %ebp to its prior state before returning
# so we have to push it
pushl %ebp
# This is because we don't want to modify the stack pointer, so we use %ebp
movl %esp, %ebp
# This moves the first argument to %eax
# 4(%ebp) holds the return address, and
# 8(%ebp) holds the first parameter.
movl 8(%ebp), %eax
# If the number is 1, that is our base case, and we simply return
# (1 is already in %eax as the return value)
cmpl $1, %eax
je end_factorial
# otherwise, decrease the value
decl %eax
# push it for our call to factorial
pushl %eax
# call factorial
call factorial
# %eax has the return value, so we reload our parameter into %ebx
movl 8(%ebp), %ebx
# multiply that by the result of the last call to factorial (in %eax)
# the answer is store in %eax, which is good since that's where return values go
imull %ebx, %eax

end_factorial:
# standard function return stuff
# have to restore %ebp and %esp to where they were before the function started
# return to the function (this pops the return value, too)
movl %ebp, %esp
popl %ebp
ret
