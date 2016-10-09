#!/usr/bin/python
# Filename: try_special_function.py


class Foo():
    def __init__(self, name):
        self.name = name
        print("call __init__ function")

    def __del__(self):
        print("call __del__ function")

    def __str__(self):
        return "My name is {0}".format(self.name)

    def __getitem__(self, key):
        print("trying to use __getitem__, but this method is not implement")
        print("key is {0}".format(key))
        return "null"

    def __len__(self):
        print("trying to use __len__, but this method is not implement")
        return 0

    def __lt__(self, other):
        print("trying to use __lt__")
        return self.name < other.name

    def __le__(self, other):
        print("trying to use __le__")
        return self.name <= other.name


f1 = Foo("Hello")
f2 = Foo("World")
print(f1)
print(f2)
# f1[0]
# len(f1)
print(f1 < f2)
print(f1 > f2)
print(f1 == f2)
print(f1 <= f2)
print(f1 >= f2)
del f1
del f2
