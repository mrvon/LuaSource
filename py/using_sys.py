#!/usr/bin/python
# Filename: using_sys.py


import sys
import os

print("The command line arguments are:")

for i in sys.argv:
    print(i)

print("\n\nThe PYTHON PATH is", sys.path, "\n")
print("PWD: ", os.getcwd())
print(__name__)
