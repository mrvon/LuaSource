#!/usr/bin/python
# Filename: func_global.py

x = 50

def func():
    global x

    print("x is", x)

    x = 2
    print("Changed global x to", x)

func()
print("Values of x is", x)
