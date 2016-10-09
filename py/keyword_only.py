#!/usr/bin/python
# Filename: keyword_only.py


def total(initial=5, *numbers, vegetables):
    count = initial
    for number in numbers:
        count += number
    count += vegetables
    return count

print(total(10, 1, 2, 3, vegetables=50))


def total_1(initial=5, *numbers):
    count = initial
    for number in numbers:
        count += number
    return count

print(total_1(10, 1, 2, 3))


def total_2(*numbers):
    count = 0
    for number in numbers:
        count += number
    return count

print(total_2(10, 1, 2, 3))
