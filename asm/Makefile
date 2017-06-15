AS = as --32
LD = ld -m elf_i386

# bundle all
all: exit maximum power factorial

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
