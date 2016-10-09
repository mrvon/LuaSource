M = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
]

row_0 = M[0]
print(row_0)

col_1 = [row[1] for row in M]
print(col_1)

print(M)

print([row[1] for row in M])
print([row[1] + 1 for row in M])
print([row[1] for row in M if row[1] % 2 == 0])

test_string = "Hello World"
print("".join([char for char in test_string if char != " "]))

print(M)
diag = [M[i][i] for i in [0, 1, 2]]
print(diag)

doubles = [c * 2 for c in 'spam']
print(doubles)

print(list(range(4)))
print(list(range(-6, 7, 2)))

print([[x ** 2, x ** 3] for x in range(4)])

G = (sum(row) for row in M)
print(next(G))
print(next(G))
print(next(G))

print(list(map(sum, M)))
print(M)
print([sum(row) for row in M])
print({sum(row) for row in M})

print({i: sum(M[i]) for i in range(3)})

print([ord(x) for x in "spaam"])
print({ord(x) for x in "spaam"})
print({x: ord(x) for x in "spamm"})
print(ord(x) for x in "spaam")

D = {
    "food": "Spam",
    "quantity": 4,
    "color": "pink",
}

print(D)
print(D["food"])
D["quantity"] += 1
print(D)

D = {}
D["name"] = "Bob"
D["job"] = "dev"
D["age"] = 40
print(D)
print(D["name"])

bob1 = dict(name="Bob", job="dev", age=40)
print(bob1)

bob2 = dict(zip(['name', 'job', 'age'], ['Bob', 'dev', 40]))
print(bob2)

rec = {
    "name": {"first": "Bob", "last": "Smith"},
    "job": ["dev", "mgr"],
    "age": 40.5
}
print(rec["name"])
print(rec["name"]["last"])
print(rec["job"])
print(rec["job"][-1])
print(rec["job"][0])
rec["job"].append("janitor")
print(rec["job"])

D = {
    'a': 1,
    'b': 2,
    'c': 3,
}
D['e'] = 99
print(D)
# D['f']

print('f' in D)
if 'f' not in D:
    print("missing")
    print("no, really...")
else:
    print("missing")

print(D)

value = D.get('x', 0)
print(value)
value = D.get('e', 0)
print(value)
value = D['e'] if 'e' in D else 0
print(value)
if 'e' in D:
    print(D['e'])
else:
    print(0)
