# bundle all
all: server trivial_client raw_sender raw_receiver

# socket server
server: socket_server.c
	cc -o $@ socket_server.c -lpthread

trivial_client: trivial_client.c
	cc -o $@ trivial_client.c

raw_sender: raw_sender.c
	cc -o $@ raw_sender.c

raw_receiver: raw_receiver.c
	cc -o $@ raw_receiver.c

# clean auto generate file
clean:
	rm -f server
	rm -f trivial_client
	rm -f raw_sender
	rm -f raw_receiver
