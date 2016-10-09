#!/usr/bin/python
# Filename: lambda.py


def make_repeater(n):
    return lambda s: s * n

twice = make_repeater(2)

print(twice("word"))
print(twice(5))

points = [{'x' : 2, 'y' : 3},
          {'x' : 4, 'y' : 1}]

print(points)
# points.sort(lambda a, b : a['x'] < b['x'])
# print(points)
