#!/usr/bin/python
# Filename: try_except.py


try:
    text = input("Enter something --> ")
except EOFError:
    print("Why did you do an EOF on me?")
except KeyboardInterrupt:
    print("You canceled the operation.")
else:
    print("You entered {0}".format(text))
