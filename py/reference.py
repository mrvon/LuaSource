#!/usr/bin/python
# Filename: reference.py


print("Simple Assignment")
shoplist = ["apple", "mango", "carrot", "banana"]
mylist = shoplist  # mylist is just another name pointing to the same object!

print("shoplist is", shoplist)
print("mylist is ", mylist)

del shoplist[0] # I purchased the first item, so I remove it from the list

print("shoplist is", shoplist)
print("mylist is ", mylist)
# notice that both shoplist and mylist both print the same list without
# the 'apple' confirming that they point to the same object

print("Copy by making a full slice")
mylist = shoplist[:] # make a copy by doing a full slice
del mylist[0] # remove first item

print("shoplist is", shoplist)
print("mylist is ", mylist)
# notice that now the two lists are different

# Test for integer
a = 10
b = a
a = 12
print("A is", a)
print("B is", b)

# Test for string
str_a = "Hello"
str_b = str_a
# del str_a[0] TypeError: 'str' object doesn't support item deletion
print("StrA is", str_a)
print("StrB is", str_b)

# Test for tuple
tuple_1 = ("yes", "no")
tuple_2 = tuple_1
# del tuple_1[0] - TypeError: 'tuple' object doesn't support item deletion
print("Tuple 1 is", tuple_1)
print("Tuple 2 is", tuple_2)

# Test for list
list_1 = ["yes", "no"]
list_2 = list_1
del list_1[0]
print("List 1 is", list_1)
print("List 2 is", list_2)

# Test for dict
dict_1 = {
    "name" : "mrvon",
    "address" : "guangzhou"
}
dict_2 = dict_1
dict_1["age"] = 23
print("Dict 1 is", dict_1)
print("Dict 2 is", dict_2)

# Test for set
set_1 = {
    "name",
    "address",
    "age"
}
set_2 = set_1
set_1.remove("age")
print("Set 1 is", set_1)
print("Set 2 is", set_2)
