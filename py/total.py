#!/usr/bin/python
# Filename: total.py


def total(initial=5, *numbers, **keywords):
    count = initial
    for number in numbers:
        count += number
    for key in keywords:
        count += keywords[key]
    return count

print(total(10, 1, 2, 3, vegetables=50, fruits=100))


def test(*numbers, **keywords):
    print(numbers)
    print(keywords)

test(10, 1, 2, 3, vegetables=50, fruits=100)
