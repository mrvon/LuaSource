.code32
.include "linux.s"
.include "record_def.s"

.section .data

# Constant data of the records wa want to write each text data item is padded to
# the proper length with null(i.e. 0) bytes

# .rept is used to pad each item.
# .rept tells the assembler to repeat the section between .rept and .endr the
# number of times specified. This is used in this program to add extra null
# characters at the end of each field to fill it up

record1:
.ascii "Fredrick\0"
.rept 31 # Padding to 40 byte
.byte 0
.endr

.ascii "Bartlett\0"
.rept 31 # Padding to 40 byte
.byte 0
.endr

.ascii "4242 S Prairie\nTulsa, Ok 55555\0"
.rept 209 # Padding to 240 bytes
.byte 0
.endr

.long 45

record2:
.ascii "Marilyn\0"
.rept 32 # Padding to 40 bytes
.byte 0
.endr

.ascii "Taylor\0"
.rept 33 # Padding to 40 bytes
.byte 0
.endr

.ascii "2224 S Johannan St\nChicago, IL 12345\0"
.rept 203 # Padding to 240 bytes
.byte 0
.endr

.long 29

record3:
.ascii "Derrick\0"
.rept 32 # Padding to 40 bytes
.byte 0
.endr

.ascii "McIntire\0"
.rept 31 # Padding to 40 bytes
.byte 0
.endr

.ascii "500 W Oakland\nSan Diego, CA 54321\0"
.rept 206 # Padding to 240 bytes
.byte 0
.endr

.long 36

# This is the name of the file we will write to

file_name:
.ascii "records.bin\0"

.equ ST_FD, -4

.globl _start
_start:

# copy the stack pointer to %ebp
movl %esp, %ebp
# allocate space to hold the file descriptor
subl $4, %esp

# open the file
movl $SYS_OPEN, %eax
movl $file_name, %ebx
# this says to create if it doesn't exist, and open for writing
movl $0101, %ecx
movl $0666, %edx
int $LINUX_SYSCALL

# Store the file descriptor away
movl %eax, ST_FD(%ebp)

# Write the first record
pushl ST_FD(%ebp)
pushl $record1
call write_record
add $8, %esp

# Write the second record
pushl ST_FD(%ebp)
pushl $record2
call write_record
add $8, %esp

# Write the third record
pushl ST_FD(%ebp)
pushl $record3
call write_record
add $8, %esp

# Close the file descriptor
movl $SYS_CLOSE, %eax
movl ST_FD(%ebp), %ebx
int $LINUX_SYSCALL

# Exit the program
movl $SYS_EXIT, %eax
movl $0, %ebx
int $LINUX_SYSCALL
