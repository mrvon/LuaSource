import socket


def find_service_name_tcp():
    protocol_name = 'tcp'
    for port in [80, 25]:
        print('Port: {} => service name: {} Protocal: {}'.format(
            port,
            socket.getservbyport(port, protocol_name),
            protocol_name))


def find_service_name_udp():
    protocol_name = 'udp'
    for port in [53]:
        print('Port: {} => service name: {} Protocal: {}'.format(
            port,
            socket.getservbyport(port, protocol_name),
            protocol_name))


if __name__ == "__main__":
    find_service_name_tcp()
    find_service_name_udp()
