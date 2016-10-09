a = {
    1 : 1,
    2 : 2,
    3 : 3,
}

ls = []

for key, _ in a.items():
    ls.append(str(key))

comma = ","
print(comma.join(ls))
