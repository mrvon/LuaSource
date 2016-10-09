#!/usr/bin/python
# Filename: set.py


# bri = set(["brazil", "russia", "india"])
bri = {"brazil", "russia", "india"}
print("india" in bri)
print("usa" in bri)

bric = bri.copy()
bric.add("china")

print(bric.issuperset(bri))

bri.remove("russia")
print(bri)
print(bric)
print(bri & bric)
print(bri.intersection(bric))
print(bri | bric)
print(bri.union(bric))
