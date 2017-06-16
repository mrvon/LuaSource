AS = as --32
LD = ld -m elf_i386

# bundle all
all: exit maximum power factorial factorial2 square toupper

exit: exit.s
	$(AS) exit.s -o exit.o
	$(LD) exit.o -o exit

maximum: maximum.s
	$(AS) maximum.s -o maximum.o
	$(LD) maximum.o -o maximum

power: power.s
	$(AS) power.s -o power.o
	$(LD) power.o -o power

factorial: factorial.s
	$(AS) factorial.s -o factorial.o
	$(LD) factorial.o -o factorial

factorial2: factorial2.s
	$(AS) factorial2.s -o factorial2.o
	$(LD) factorial2.o -o factorial2

square: square.s
	$(AS) square.s -o square.o
	$(LD) square.o -o square

toupper: toupper.s
	$(AS) toupper.s -o toupper.o
	$(LD) toupper.o -o toupper

# clean auto generate file
clean:
	rm -f exit.o
	rm -f exit
	rm -f maximum.o
	rm -f maximum
	rm -f power.o
	rm -f power
	rm -f factorial.o
	rm -f factorial
	rm -f factorial2.o
	rm -f factorial2
	rm -f square.o
	rm -f square
	rm -f toupper.o
	rm -f toupper
