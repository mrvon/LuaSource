#!/usr/bin/python
# Filename: using_dict.py


# 'ab' is short for 'a'ddress 'b'ook

ab = {
    "Swaroop"   : "Swaroop@swaroopch.com",
    "Larry"     : "Larry@wall.org",
    "Matsumoto" : "matz@ruby-lang.org",
    "Spammer"   : "Spammer@hotmail.com"
}

print("Swaroop's address is", ab["Swaroop"])
print("Spammer's address is", ab["Spammer"])

# Deleting a key-value pair
del ab["Spammer"]
if "Spammer" not in ab:
    print("Spammer war already deleted")

print("\n")
print("There are {0} contacts in the address-book" . format(len(ab)))
print("\n")

for name, address in ab.items():
    print("Contact {0} at {1}" . format(name, address))

# Adding a key-value pair
ab["Guido"] = "guido@python.org"

# W601 .has_key() is deprecated, use in instead
if "Guido" in ab:
    print("\n")
    print("Guido's address is", ab["Guido"])


