import socket


def print_machine_info():
    host_name = socket.gethostname()
    ip_address = socket.gethostbyname(host_name)
    print('Host name: {}'.format(host_name))
    print('IP address: {}'.format(ip_address))


if __name__ == '__main__':
    print_machine_info()
