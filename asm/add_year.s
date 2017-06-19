.code32
.include "linux.s"
.include "record_def.s"

.section .data
in_file_name:
.ascii "records.bin\0"

out_file_name:
.ascii "records2.bin\0"

no_open_file_code:
.ascii "0001: \0"

no_open_file_msg:
.ascii "Can't Open Input file\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

.section .text

# main program
.globl _start
_start:

# there are the locations on the stack where we will store the input and output
# descriptors (FYI - we could have used memory addresses in a .data section
# instead)
.equ ST_IN_FD, -4
.equ ST_OUT_FD, -8

# copy the stack pointer to %ebp
movl %esp, %ebp
# allocate space to hold the file descriptors
subl $8, %esp

# open the input file
movl $SYS_OPEN, %eax
movl $in_file_name, %ebx
movl $0, %ecx
movl $0666, %edx
int $LINUX_SYSCALL

# save input file descriptor
movl %eax, ST_IN_FD(%ebp)

# error checking
cmpl $0, %eax
jge continue_processing

# send the error
pushl $no_open_file_msg
pushl $no_open_file_code
call error_exit
addl $8, %esp

continue_processing:

# open the output file
movl $SYS_OPEN, %eax
movl $out_file_name, %ebx
movl $0101, %ecx
movl $0666, %edx
int $LINUX_SYSCALL

# save output file descriptor
movl %eax, ST_OUT_FD(%ebp)

# error checking
cmpl $0, %eax
jge continue_processing2

# send the error
pushl $no_open_file_msg
pushl $no_open_file_code
call error_exit
addl $8, %esp

continue_processing2:

loop_begin:
pushl ST_IN_FD(%ebp)
pushl $record_buffer
call read_record
addl $8, %esp

# returns the number of bytes read
# if it isn't the same number we requested, then it's either an end_of_file or 
# and error, so we're quitting
cmpl $RECORD_SIZE, %eax
jne loop_end

# increment the age
incl record_buffer + RECORD_AGE

# write the record out
pushl ST_OUT_FD(%ebp)
pushl $record_buffer
call write_record
addl $8, %esp

jmp loop_begin

loop_end:
movl $SYS_EXIT, %eax
movl $0, %ebx
int $LINUX_SYSCALL
