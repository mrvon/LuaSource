import socket
import argparse


host = 'localhost'
data_payload = 2048
backlog = 5


def echo_server(port):
    ''' A simple echo server '''
    # Create a TCP socket
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # Enable reuse address/port
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    # Bind the socket to the port
    server_address = (host, port)
    print('Starting up echo server on {} port {}'.format(server_address[0], server_address[1]))
    s.bind(server_address)
    # Listen to clients, backlog argument specifies the max number of queued connections
    s.listen(backlog)
    while True:
        print('Waiting to receive message from client')
        client, address = s.accept()
        data = client.recv(data_payload)
        if data:
            print('Recv data: {}'.format(data))
            client.send(data)
            print('Send {} bytes back to {}', data, address)
        # end connection
        client.close()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Socket Server Example')
    parser.add_argument('--port', action='store', dest='port', type=int, required=True)

    given_args = parser.parse_args()
    port = given_args.port
    echo_server(port)
