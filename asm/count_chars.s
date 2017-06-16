.code32

# PURPOSE
#
# Count the characters until a null byte is reached.

# INPUT
#
# The address of the character string

# OUTPUT
#
# Returns the count in %eax

# PROCESS
# 
# Registers used
# %ecx - character count
# %al  - current character
# %edx - current character address

# this is where our one parameter is on the stack
.equ ST_STRING_START_ADDRESS, 8

.section .text

.globl count_chars
.type count_chars, @function
count_chars:

pushl %ebp
movl %esp, %ebp

# counter starts at zero
movl $0, %ecx

# start address of data
movl ST_STRING_START_ADDRESS(%ebp), %edx

count_loop_begin:
# grab the current character
movb (%edx), %al
# is it null?
cmpb $0, %al
# if yes, we're done
je count_loop_end
# otherwise, increment the counter and the pointer
incl %ecx
incl %edx
# go back to the beginning of the loop
jmp count_loop_begin

count_loop_end:
# we're done. move the count into %eax and return
movl %ecx, %eax

movl %ebp, %esp
popl %ebp
ret
