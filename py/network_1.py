import socket

host_name = socket.gethostname()
ip_address = socket.gethostbyname(host_name)

print('Host name: {}'.format(host_name))
print('IP address: {}'.format(ip_address))
