# bundle all
all: server

# unix wc
server: socket_server.c
	cc -o $@ socket_server.c -lpthread

# clean auto generate file
clean:
	rm -f server
