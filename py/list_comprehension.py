#!/usr/bin/python
# Filename: list_comprehension.py


list_one = [2, 3, 4]
list_two = [2 * i for i in list_one if i > 2]
print(list_one)
print(list_two)


def powersum(power, *args):
    '''Return the sum of each argument raised to specified power.'''
    print(type(*args))
    print(type(args))
    total = 0
    for i in args:
        total += pow(i, power)
    return total

print(powersum.__doc__)
print(powersum(2, 1, 2, 3, 4, 5))
print(1 ** 2 + 2 ** 2 + 3 ** 2 + 4 ** 2 + 5 ** 2)
print(pow(2, 10))
print(powersum(2, 10))
print("hello world")
print(eval("2 * 3") + 4)

my_list = ['item']
# assert(len(my_list) >= 1)
my_list.pop()
# assert(len(my_list) >= 1)
