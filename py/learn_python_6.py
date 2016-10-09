table = {
    '1975': 'Holy Grail',
    '1979': 'Life of Brain',
    '1983': 'The Meaning of Life',
}

year = '1983'
movie = table[year]
print(movie)

# for year in table:
#     print(year + '\t' + table[year])

for year in table.keys():
    print(year + '\t' + table[year])

print([year for (year, title) in table.items() if title == 'Holy Grail'])

table = {
    'Holy Grail': '1975',
    'Life of Brain': '1979',
    'The Meaning of Life': '1983',
}

print(table['Holy Grail'])
print(list(table.items()))

print([title for (title, year) in table.items() if year == '1975'])

print(table)
K = 'Holy Grail'
print(table[K])
V = '1975'
print([key for (key, value) in table.items() if value == V])
print([key for key in table.keys() if table[key] == V])

# L = []
# L[99] = 'spam'

D = {}
D[99] = 'spam'
print(D[99])
print(D)

table = {
    1975: 'Holy Grail',
    1979: 'Life of Brain',
    1983: 'The Meaning of Life',
}

print(table[1975])
print(list(table.items()))

Matrix = {}
Matrix[(2, 3, 4)] = 88
Matrix[(7, 8, 9)] = 99
print(Matrix[(2, 3, 4)])
print(Matrix)

if (2, 3, 6) in Matrix:
    print(Matrix(2, 3, 6))
else:
    print(0)

try:
    print(Matrix[(2, 3, 6)])
except KeyError:
    print(0)

print(Matrix.get((2, 3, 4), 0))
print(Matrix.get((2, 3, 6), 0))

rec = {
    'name': 'Bob',
    'jobs': ['developer', 'manager'],
    'web': 'www.bobs.org/~Bob',
    'home': {'state': 'Overworked', 'zip': 12345},
}
print(rec['name'])
print(rec['jobs'])
print(rec['jobs'][1])
print(rec['home']['zip'])

D = {}
D['name'] = 'Bob'
D['age'] = 40
print(D)
print(dict(name='Bob', age=40))
# print(dict[('name', 'Bob'), ('age', 40)])
print(dict(zip(['name', 'Bob'], ['age', 40])))

print(dict.fromkeys(['a', 'b'], 0))

D = {}
D['state1'] = True
print(D)
print('state1' in D)

S = set()
S.add('state1')
print(S)
print('state1' in S)

T = ('cc', 'aa', 'dd', 'bb')
# temp = list(t)
# temp.sort()
# print(temp)
# t = tuple(temp)
# print(temp)

# print(sorted(T))

T = (1, 2, 3, 4, 5)
L = [x + 20 for x in T]
print(L)

print((1, 2) + (3, 4))
print((1, 2) * 4)
T = (1, 2, 3, 4)
print(T)
print(T[0], T[1:3])

x = (40)
print(repr(x))

x = (40, )
print(repr(x))

T = (1, 2, 3, 2, 4, 2)
print(T.index(2))
print(T.index(2, 2))
print(T.count(2))

bob = ('bob', 40.5, ['dev', 'mgr'])
print(bob)
bob[2].append('foo')
print(bob[0], bob[2])

bob = dict(name='Bob', age=40.5, jobs=['dev', 'mgr'])
print(bob)
print(bob['name'])
print(bob['jobs'])

print(tuple(bob.values()))
print(list(bob.items()))


from collections import namedtuple

Rec = namedtuple('Rec', ['name', 'age', 'jobs'])
bob = Rec('Bob', age=40.5, jobs=['dev', 'mgr'])
print(bob)

print(bob[0], bob[2])
print(bob.name, bob.jobs)

O = bob._asdict()
print(O['name'], O['jobs'])
print(O)

my_file = open('myfile.txt', 'w')
print(my_file.write('hello text file\n'))
print(my_file.write('goodbye text file\n'))
my_file.close()

my_file = open('myfile.txt')
print(my_file.readline(), end='')
print(my_file.readline(), end='')
print(my_file.readline(), end='')
my_file.close()

my_file = open('myfile.txt')
print(repr(my_file.read()))
my_file.close()

my_file = open('myfile.txt')
print(my_file.read())
my_file.close()

print("-------------------------------------------")

for line in open('myfile.txt'):
    print(line, end='')

my_file = open('myfile.txt')

while True:
    char = my_file.read(1)
    if not char:
        break
    print(repr(char), end='/')

my_file.close()
