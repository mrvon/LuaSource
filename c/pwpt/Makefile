CC = gcc

# bundle all
all:                \
	alarm           \
	alarm_fork		\
	alarm_thread	\

clean:
	rm -f alarm
	rm -f alarm_fork
	rm -f alarm_thread

alarm: alarm.c
	$(CC) -o $@ alarm.c

alarm_fork: alarm_fork.c
	$(CC) -o $@ alarm_fork.c

alarm_thread: alarm_thread.c
	$(CC) -o $@ alarm_thread.c -pthread
