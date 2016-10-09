#!/usr/bin/python
# Filename: func_key.py

def func(a, b=5, c=10):
    print("a is", a, "and b is", b, "and c is", c)

func(3, 7)
func(3)
func(25, c=24)
func(c=1, a=1)
