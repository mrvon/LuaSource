AS = as --32
LD = ld -m elf_i386

# bundle all
all: exit maximum power factorial factorial2 square toupper toupper2 heynow \
	write_records read_records

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

toupper2: toupper2.s
	$(AS) toupper2.s -o toupper2.o
	$(LD) toupper2.o -o toupper2

heynow: heynow.s
	$(AS) heynow.s -o heynow.o
	$(LD) heynow.o -o heynow

write_records: write_records.s
	$(AS) write_record.s -o write_record.o
	$(AS) write_records.s -o write_records.o
	$(LD) write_record.o write_records.o -o write_records

read_records: read_records.s
	$(AS) write_newline.s -o write_newline.o
	$(AS) count_chars.s -o count_chars.o
	$(AS) read_record.s -o read_record.o
	$(AS) read_records.s -o read_records.o
	$(LD) write_newline.o count_chars.o read_record.o read_records.o -o read_records

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
	rm -f toupper2.o
	rm -f toupper2
	rm -f heynow.o
	rm -f heynow
	rm -f write_records.o
	rm -f write_records
	rm -f read_records.o
	rm -f read_records
