import socket
import struct
import time


NTP_SERVER = '0.uk.pool.ntp.org'
TIME1970 = 2208988800


def sntp_client():
    client = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    send_str = '\x1b' + 47 * '\0'
    send_data = send_str.encode()

    print("SEND PACKET: {}".format(send_data), end='\n\n')

    client.sendto(send_data, (NTP_SERVER, 123))

    recv_data, address = client.recvfrom(1024)

    print("RECV PACKET: {}".format(recv_data), end='\n\n')

    if recv_data:
        print('Responce received from: {}'.format(address))

    t = struct.unpack('!12I', recv_data)[10]
    t -= TIME1970
    print('\tTime: {}'.format(time.ctime(t)))


if __name__ == '__main__':
    sntp_client()
