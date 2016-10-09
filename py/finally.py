#!/usr/bin/python
# Filename: finally.py


import time

try:
    f = open("poem.txt")
    while True:
        line = f.readline()
        if len(line) == 0:
            break
        print(line, end="")
        time.sleep(2)
except KeyboardInterrupt:
    print("!! You canceled the reading from the file.")
finally:
    f.close()
    print("(Cleaning up: Closed the file)")
