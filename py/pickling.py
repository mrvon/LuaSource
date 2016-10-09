#!/usr/bin/python
# Filename: pickling.py


import pickle

# the name of the file where we will store the object
shoplistfile = "shoplist.data"
# the list of things to buy
shoplist = ['apple', 'mango', 'carrot']

# Write to the file
f = open(shoplistfile, "wb")
pickle.dump(shoplist, f)  # dump the object to a file
print("Origin Object:", shoplist)
f.close()

del shoplist  # destroy the shoplist variable

# Read back from the storage
f = open(shoplistfile, "rb")
storedlist = pickle.load(f)  # load the object from the file
print("Load Object:", storedlist)
