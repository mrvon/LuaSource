import socket


SEND_BUF_SIZE = 4096
RECV_BUF_SIZE = 4096


def modify_buff_size():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # Get the size of the socket's send buffer
    send_buf_size = s.getsockopt(socket.SOL_SOCKET, socket.SO_SNDBUF)
    print('Send buffer size [Before]: {}'.format(send_buf_size))

    recv_buf_size = s.getsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF)
    print('Recv buffer size [Before]: {}'.format(recv_buf_size))

    s.setsockopt(socket.SOL_TCP, socket.TCP_NODELAY, 1)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_SNDBUF, SEND_BUF_SIZE)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, RECV_BUF_SIZE)

    send_buf_size = s.getsockopt(socket.SOL_SOCKET, socket.SO_SNDBUF)
    print('Send buffer size [After]: {}'.format(send_buf_size))

    recv_buf_size = s.getsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF)
    print('Recv buffer size [After]: {}'.format(recv_buf_size))


if __name__ == '__main__':
    modify_buff_size()
