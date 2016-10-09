import sys
import socket
import argparse


def main():
    # setup argument parsing
    parser = argparse.ArgumentParser(description='Socket Error Examples')
    parser.add_argument('--host', action='store', dest='host', required=False)
    parser.add_argument('--port', action='store', dest='port', required=False)
    parser.add_argument('--file', action='store', dest='file', required=False)

    given_args = parser.parse_args()

    host = given_args.host
    port = int(given_args.port)
    file_name = given_args.file

    # print(type(host))
    # print(type(port))
    # print(type(file_name))

    # First try-except block -- create socket
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    except socket.error as e:
        print('Error creating socket: {}'.format(e))
        sys.exit(1)

    # Second try-except block -- connect to given host/port
    try:
        s.connect((host, port))
    except socket.gaierror as e:
        print('Connection error: {}'.format(e))
        sys.exit(1)

    # Third try-except block -- sending data
    try:
        request_str = 'GET {} HTTP/1.0\r\n\r\n'.format(file_name)
        request_data = request_str.encode(encoding='utf-8')
        s.sendall(request_data)
    except socket.error as e:
        print('Error sending data: {}'.format(e))
        sys.exit(1)

    while True:
        # Fourth try-except block -- waiting to receive data from remote host
        try:
            buf = s.recv(2048)
        except socket.error as e:
            print("Error receiving data: {}".format(e))
            sys.exit(1)

        if len(buf) == 0:
            break

        # write the received data
        receive_str = buf.decode(encoding='utf-8')
        sys.stdout.write(receive_str)


if __name__ == '__main__':
    main()
