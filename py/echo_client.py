import socket
import argparse
import sys


host = 'localhost'
data_payload = 2


def echo_client(port, message):
    ''' A simple echo client '''
    # Create a TCP/IP socket
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_address = (host, port)

    try:
        # Connect the socket to the server
        print("Connecting to {} port {}".format(server_address[0], server_address[1]))
        s.connect(server_address)
    except socket.gaierror as e:
        print('Connection error: {}'.format(e))
        sys.exit(1)

    try:
        print('Sending: {}'.format(message))
        s.sendall(message.encode(encoding='utf-8'))
    except socket.error as e:
        print('Error sending data: {}'.format(e))
        sys.exit(1)

    # Look for the responce
    try:
        amount_received = 0
        amount_expected = len(message)
        while amount_received < amount_expected:
            data = s.recv(data_payload)
            amount_received += len(data)
            print('Received: {}'.format(data.decode(encoding='utf-8')))
    except socket.errno as e:
        print('Socket error: {}'.format(e))
    except Exception as e:
        print('Other exception: {}'.format(e))
    finally:
        print('Closing connection to the server')
        s.close()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Socket Client Example')
    parser.add_argument('--port', action='store', dest='port', type=int, required=True)
    parser.add_argument('--message', action='store', dest='message', type=str, required=True)

    given_args = parser.parse_args()
    port = given_args.port
    message = given_args.message

    echo_client(port, message)
