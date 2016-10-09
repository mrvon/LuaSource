#!/usr/bin/python
# Filename: func_return.py


def maximum(x, y):
    if x > y:
        return x
    else:
        return y

print(maximum(2, 3))


def return_none():
    return None

print(return_none())


def return_none_2():
    pass

print(return_none_2())
