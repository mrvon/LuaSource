# PURPOSE
#
# Program to manage memory usage - allocates and deallocates memory as requested

# NOTES
#
# The programs using these routines will ask for a certain size of memory.
# We actually use more than that size, but we put it at the beginning,
# before the pointer we hand back. We add a size field and an
# AVAILABLE/UNAVAILABLE marker. So, the memory looks like this.

# | Available Marker | Size of memory | Actual memory locations |
#								    	^-- Returned pointer points here

# The pointer we return only points to the actual locations requested to make
# it easier for the calling program. It also allows us to change our structure 
# without the calling program have to change at all.

.code32
.include "linux.s"

.section .data

# Global variables

# This points to the beginning of the memory we are managing
heap_begin:
.long 0

# This points to one location past the memory we are managing
current_break:
.long 0

initialize:
.long 0

# Structure information

# size of space for memory region header
.equ HEADER_SIZE, 8

# location of the "available" flag in the header
.equ HDR_AVAIL_OFFSET, 0

# location of the size field in the header
.equ HDR_SIZE_OFFSET, 4

# Constants

# This is the number we will use to mark space that has been given out
.equ UNAVAILABLE, 0

# This is the number we will use to mark space that has been returned, and is
# available for giving
.equ AVAILABLE, 1


.section .text

# Functions

# allocate_init
#
# PURPOSE
#
# call this function to initialize the functions (specifically, this sets
# heap_begin and current_break). This has no parameters and no return value.
.type allocate_init, @function
allocate_init:

# standard start stuff
pushl %ebp
movl %esp, %ebp

# if the brk system call is called with 0 in %ebx, it returns the last valid
# usable address
movl $SYS_BRK, %eax # find out where the break is
movl $0, %ebx
int $LINUX_SYSCALL

# %eax now has the last valid address, and we want the memory location after that
incl %eax

# store the current_break
movl %eax, current_break

# store the current_break as our first address. This will cause the allocate 
# function to get more memory from Linux the first time it is run
movl %eax, heap_begin

# standard return stuff
movl %ebp, %esp
popl %ebp
ret


# allocate
#
# PURPOSE
#
# this function is used to grab a section of memory. It checks to see if there
# are any free blocks, and, if not, if ask Linux for a new one.

# PARAMETERS:
# 
# this function has one parameter - the size of the memory block we want to
# allocate

# RETURN VALUES;
#
# this function returns the address of the allocated memory in %eax.
# if there is not memory available, it will return 0 in %eax.

# VARIABLES USED:
#
# %ecx - hold the size of the requested memory (first/only parameter)
# %eax - current memory region being examined
# %ebx - current break position
# %edx - size of current memory region

# we scan through each memory region starting with heap_begin. we look at the
# size of each one, and if it has been allocated. if it's big enough for the
# requested size, and its available, it grabs that one. if it does not find a
# region large enough, it ask Linux for more memory. In that case, it moves
# current_break up

# stack position of the memory size to allocate
.equ ST_MEM_SIZE, 8

.globl allocate
.type allocate, @function
allocate:

# standard function stuff
pushl %ebp
movl %esp, %ebp

cmpl $0, initialize
jne begin

movl $1, initialize
call allocate_init

begin:

# %ecx will hold the size we are looking for (which is first and only parameter)
movl ST_MEM_SIZE(%ebp), %ecx

# %eax will hold the current search location
movl heap_begin, %eax

# %ebx will hold the current break
movl current_break, %ebx

# here we iterate through each memory region
alloc_loop_begin:

# need more memory if these are equal
cmpl %ebx, %eax
je move_break

# grab the size of this memory
movl HDR_SIZE_OFFSET(%eax), %edx

# if the space is unavailable, go to the next one
cmpl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
je next_location

# if the space is available, compare the size to the needed size. If its big
# enough, go to allocate_here
cmpl %edx, %ecx
jle allocate_here

next_location:
# the total size of the memory region is the sum of the size requested
# (currently stored in %edx), plus another 8 bytes for the header (4 for the
# AVAILABLE/UNAVAILABLE flag, and 4 for the size of the region). So, adding
# %edx and $8 to %eax will get the address of the next memory region.
addl $HEADER_SIZE, %eax
addl %edx, %eax

# go look at the next location
jmp alloc_loop_begin

allocate_here:
# if we've made it here, that means that the region header of the region to
# allocate is in %eax

#mark space as unavailable
movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
# move %eax past the header to the usable memory (since that's what we return)
addl $HEADER_SIZE, %eax

# standard return stuff
movl %ebp, %esp
popl %ebp
ret

move_break:
# if we've made it here, that means that we have exhausted all addressable
# memory, and we need to ask for more.
# %ebx holds the current endpoint of the data, and %ecx holds its size

# we need to increase %ebx to where we want memory to end, so we add space for
# the headers structure
addl $HEADER_SIZE, %ebx
# add space to the break for the data requested
addl %ecx, %ebx

# now its time to ask Linux for more memory

# save needed registers
pushl %eax
pushl %ecx
pushl %ebx

# reset the break (%ebx has the requested break point)
movl $SYS_BRK, %eax
int $LINUX_SYSCALL

# under normal conditions, this could return the new break in %eax, which will
# be either 0 if it fails, or it will be equal to or larger than we asked for.
# we don't care in this program where it actually sets the break, so as long as
# %eax isn't 0, we don't care what it is

# check for error conditions
cmpl $0, %eax
je error

# restore saved registers
popl %ebx
popl %ecx
popl %eax

# save this memory as unavailable, since we're about to give it away
movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
# set the size of the memory
movl %ecx, HDR_SIZE_OFFSET(%eax)

# move %eax to the actual start of usable memory
# %eax now holds the return value
addl $HEADER_SIZE, %eax

# save the new break
movl %ebx, current_break

# standard return stuff
movl %ebp, %esp
popl %ebp
ret

error:
# on error, we return zero
movl $0, %eax
# standard return stuff
movl %ebp, %esp
popl %ebp
ret


# deallocate
#
# PURPOSE
#
# the purpose of this function is to give back a region of memory to the pool
# after we're done using it.

# PARAMETERS
#
# the only parameter is the address of the memory we want to return to the
# memory pool.

# RETURN VALUES
#
# there is no return value

# PROCESSING
#
# if you remember, we actually hand the program the start of the memory that
# they can use, which is 8 storage locations after the actual start of the
# memory region. all we have to do is go back 8 locations and mark that memory
# as available, so that the allocate function knows it can use it.

# start position of the memory region to free
.equ ST_MEMORY_SEG, 4

.globl deallocate
.type deallocate, @function
deallocate:

# since the function is so simple, we don't need any of the fancy function stuff
# in this function, we don't have to save %ebp or %esp since we're not changing
# them, nor do we have to restore them at the end

# get the address of the memory to free (normally this is 8(%ebp), but since we
# didn't push %ebp or move %esp to %ebp, we can just do 4(%esp)
movl ST_MEMORY_SEG(%esp), %eax

# get the pointer to the real beginning of the memory
subl $HEADER_SIZE, %eax

# mark it as available
movl $AVAILABLE, HDR_AVAIL_OFFSET(%eax)

# this function has no return value, so we don't care what we leave in %eax
ret
