AS = as --32
LD = ld -m elf_i386

# bundle all
all: exit maximum power factorial factorial2 libfactorial square toupper \
	toupper2 heynow write_records read_records add_year add_year_inplace \
	helloworld printf_example alloc read_records_using_alloc \

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

# LD_LIBRARY_PATH=. ./factorial2
factorial2: libfactorial factorial2.s
	$(AS) factorial2.s -o factorial2.o
	$(LD) -dynamic-linker /lib/ld-linux.so.2 -o factorial2 factorial2.o \
		-lc -lfactorial -L .

libfactorial: libfactorial.s
	$(AS) libfactorial.s -o libfactorial.o
	$(LD) -shared factorial.o -o libfactorial.so

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

write_record: write_record.s
	$(AS) write_record.s -o write_record.o

read_record: read_record.s
	$(AS) read_record.s -o read_record.o

write_records: write_record write_records.s
	$(AS) write_records.s -o write_records.o
	$(LD) write_record.o write_records.o -o write_records

write_newline: write_newline.s
	$(AS) write_newline.s -o write_newline.o

count_chars: count_chars.s
	$(AS) count_chars.s -o count_chars.o

read_records: write_newline count_chars read_record read_records.s
	$(AS) read_records.s -o read_records.o
	$(LD) write_newline.o count_chars.o read_record.o read_records.o -o read_records

error_exit: error_exit.s
	$(AS) error_exit.s -o error_exit.o

add_year: read_record write_record error_exit count_chars write_newline add_year.s
	$(AS) add_year.s -o add_year.o
	$(LD) read_record.o write_record.o error_exit.o count_chars.o write_newline.o add_year.o -o add_year

add_year_inplace: read_record write_record add_year_inplace.s
	$(AS) add_year_inplace.s -o add_year_inplace.o
	$(LD) read_record.o write_record.o add_year_inplace.o -o add_year_inplace

helloworld: helloworld.s
	$(AS) helloworld.s -o helloworld.o
	$(LD) -dynamic-linker /lib/ld-linux.so.2 -o helloworld helloworld.o -lc

printf_example: printf_example.s
	$(AS) printf_example.s -o printf_example.o
	$(LD) -dynamic-linker /lib/ld-linux.so.2 -o printf_example printf_example.o -lc

alloc: alloc.s
	$(AS) alloc.s -o alloc.o

read_records_using_alloc: write_newline count_chars read_record alloc read_records_using_alloc.s
	$(AS) read_records_using_alloc.s -o read_records_using_alloc.o
	$(LD) write_newline.o count_chars.o read_record.o \
		  read_records_using_alloc.o alloc.o -o read_records_using_alloc

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
	rm -f libfactorial.o
	rm -f libfactorial.so
	rm -f square.o
	rm -f square
	rm -f toupper.o
	rm -f toupper
	rm -f toupper2.o
	rm -f toupper2
	rm -f heynow.o
	rm -f heynow
	rm -f write_record.o
	rm -f write_records.o
	rm -f write_records
	rm -f write_newline.o
	rm -f count_chars.o
	rm -f read_record.o
	rm -f read_records.o
	rm -f read_records
	rm -f error_exit.o
	rm -f add_year.o
	rm -f add_year
	rm -f add_year_inplace.o
	rm -f add_year_inplace
	rm -f helloworld.o
	rm -f helloworld
	rm -f printf_example.o
	rm -f printf_example
	rm -f alloc.o
	rm -f read_records_using_alloc.o
	rm -f read_records_using_alloc
