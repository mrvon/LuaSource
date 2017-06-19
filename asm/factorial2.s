# PURPOSE
#
# Show to use shared library libfactorial.so
.code32
.section .data
format_string:
.ascii "factorial(%d) = %d\n\0"

.section .text
.globl _start

_start:
# The factorial takes one argument
# the number we want a factorial of.
pushl $5
# run the factorial function
call factorial
# scrubs the parameter that was pushed on the stack
addl $4, %esp
# print the result
pushl %eax
pushl $5
pushl $format_string
call printf
addl $12, %esp
# exit
pushl $0
call exit
