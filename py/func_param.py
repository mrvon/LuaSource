#!/usr/bin/python
# Filename: func_param.py

def printMax(a, b):
    if a > b:
        print(a, "is maximum")
    elif a == b:
        print(a, "is equial to", b)
    else:
        print(b, "is maximum")

printMax(3, 4)

x = 50
y = 10
printMax(x, y)


def printMin(a, b):
    if a < b:
        print(a, "is minimum")
    elif a == b:
        print(a, "is equial to", b)
    else:
        print(b, "is minimum")

printMin(x, y)
