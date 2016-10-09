import os
import socket
import threading
import socketserver


# I seems socketserver.ForkingMixIn only work on unix system

SERVER_HOST = 'localhost'
SERVER_PORT = 0  # tells the kernel to pick up a port dynamically
BUF_SIZE = 1024
ECHO_MSG = 'Hello echo server!'


class ForkedClient():
    ''' A client to test forking server '''
    def __init__(self, ip, port):
        # Create a socket
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        # Connect to the server
        self.sock.connect((ip, port))

    def run(self):
        ''' Client playing with the server '''
        # Send the data to server
        current_process_id = os.getpid()
        print('PID {} Sending echo message to the server: {}'.format(current_process_id, ECHO_MSG))

        send_data_length = self.sock.send(ECHO_MSG.encode(encoding='utf-8'))
        print('Sent: {} characters, so far ...'.format(send_data_length))

        # Display server responce
        responce = self.sock.recv(BUF_SIZE)
        print('PID {} received: {}'.format(current_process_id, responce.decode()[5:]))

    def shutdown(self):
        ''' Cleanup the client socket '''
        self.sock.close()


class ForkingServerRequestHandler(socketserver.BaseRequestHandler):
    def handle(self):
        # Send the echo back to the client
        data = self.request.recv(BUF_SIZE)
        current_process_id = os.getpid()
        responce = '{}: {}'.format(current_process_id, data.decode())
        print('Server sending responce [current_process_id: data] = [{}]'.format(responce))
        self.request.send(responce.encode(encoding='utf-8'))
        return


class ForkingServer(socketserver.ForkingMixIn,
                    socketserver.TCPServer):
    ''' Nothing to add here, inherited everything necessary from parents '''
    pass


def main():
    # Launch the server
    server = ForkingServer((SERVER_HOST, SERVER_PORT),
                           ForkingServerRequestHandler)
    ip, port = server.server_address  # Retrieve the port number
    server_thread = threading.Thread(target=server.serve_forever)
    # server_thread.setDaemon(True)  # don't hang on exit
    server_thread.start()

    print('Server loop running PID: {}'.format(os.getpid()))

    # Launch the client(s)
    client1 = ForkedClient(ip, port)
    client1.run()

    client2 = ForkedClient(ip, port)
    client2.run()

    server.shutdown()
    client1.shutdown()
    client2.shutdown()
    server.socket.close()


if __name__ == '__main__':
    main()
