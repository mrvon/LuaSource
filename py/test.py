#!/usr/bin/python
# Filename: test.py

# age = 25
# name = "Swaroop"

# print("{0} is {1} years old" . format(name, age))
# print("Why is {0} playing with that python?" . format(name))
# print(name + ' is ' + str(age) + ' years old ')
# print('{0:.3}' . format(1/3))
# print('{0:_^11}' . format('hello'))
# print('{0:_^12}' . format('hello'))
# print('{0:_^13}' . format('hello'))
# print('{name} wrote {book}' . format(name="Swaroop", book="A Byte Of Python"))


import pickle
import struct
import socket


def debug(*args):
    print(args, type(args))
    # print(*args)

    buf = pickle.dumps(args)
    print(buf)
    print(len(buf))
    value = socket.htonl(len(buf))
    print(value)
    size = struct.pack('L', value)
    print(size)

    ori_size = struct.unpack('L', size)[0]
    print(ori_size)
    ori_value = socket.ntohl(ori_size)
    print(ori_value)

if __name__ == '__main__':
    # t = (9, 2, 3, 4)
    # debug(*t)
    # debug(9, 2, 3, 4)
    t = ''
    t = 'string'
    t = 'next'
    print(t)
