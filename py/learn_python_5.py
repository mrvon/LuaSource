X = set("spam")
Y = {'h', 'a', 'm'}
X.add("k")
X.remove("s")

print(X, Y)
print(X & Y)
print(X | Y)
print(X - Y)
print(X > Y)
print({n ** 2 for n in [1, 2, 3, 4]})


lst = [1, 2, 1, 3, 1]
st = set(lst)
print(lst)
print(st)
print(list(st))

print(set('spam') - set('ham'))
print(set('spam') == set('asmp'))

print('p' in set('spam'))
print('p' in 'spam')
print('ham' in ['eggs', 'spam', 'ham'])

print("-----------------------------------")

print(1 / 3)
print((2 / 3) + (1 / 2))

import decimal


d = decimal.Decimal('3.141')
print(d)
print(d + 1)

decimal.getcontext().prec = 2
print(decimal.Decimal('1.00') / decimal.Decimal('3.00'))

from fractions import Fraction

f = Fraction(2, 3)
print(f)
print(f + 1)
print(f + Fraction(1, 2))

print(1 > 2, 1 < 2)
print(bool('spam'))
# x = None
# print(x)
L = [None] * 10
print(L)

print(type(L))
print(type(type(L)))

# if (type(L) == type([])):
#     print("yes")

if isinstance(L, list):
    print("yes")

if isinstance(L, list):
    print("yes")


class Worker:

    def __init__(self, name, pay):
        self.name = name
        self.pay = pay

    def lastName(self):
        return self.name.split()[-1]

    def giveRaise(self, percent):
        self.pay *= (1.0 + percent)


bob = Worker('Bob Smith', 50000)
sue = Worker('Sue Jones', 60000)
print(bob.lastName())
print(sue.lastName())
sue.giveRaise(0.10)
print(sue.pay)

print(hex(18))
print(oct(18))
print(bin(18))
print(int("FF", 16))

print(3 / 2)
print(3 // 2)

s = 'a\0b\0c'
print(s)
print(len(s))

s = '\001\002\x03'
print(s)
print(len(s))

s = 's\tp\na\x00m'
print(s)
print(len(s))

mantra = '''Always look
    on the bright
    side of life.
'''
print(mantra)

myjob = "hacker"
for c in myjob:
    print(c, end=" ")

print("")
print("k" in myjob)
print("z" in myjob)
print("spam" in "abcspamdef")

print(repr("a\0b\0c"))
print(str("a\0b\0c"))

print(ord('我'))
print(chr(25105))
# for i in range(25100, 25100 + 100):
#     print(chr(i))

B = '1101'
I = 0
while B != '':
    I = I * 2 + (ord(B[0]) - ord('0'))
    B = B[1:]

print(I)

print(int('1101', 2))
print(bin(13))

s = 'xxxxSPAMxxxxSPAMxxxx'
print(s.replace('SPAM', 'EGGS'))
print(s.replace('SPAM', 'EGGS', 1))

X = set("spam")
Y = {'h', 'a', 'm'}
X.add("k")
X.remove("s")

print(X, Y)
print(X & Y)
print(X | Y)
print(X - Y)
print(X > Y)
print({n ** 2 for n in [1, 2, 3, 4]})


lst = [1, 2, 1, 3, 1]
st = set(lst)
print(lst)
print(st)
print(list(st))

print(set('spam') - set('ham'))
print(set('spam') == set('asmp'))

print('p' in set('spam'))
print('p' in 'spam')
print('ham' in ['eggs', 'spam', 'ham'])

print("-----------------------------------")

print(1 / 3)
print((2 / 3) + (1 / 2))

import decimal


d = decimal.Decimal('3.141')
print(d)
print(d + 1)

decimal.getcontext().prec = 2
print(decimal.Decimal('1.00') / decimal.Decimal('3.00'))

from fractions import Fraction

f = Fraction(2, 3)
print(f)
print(f + 1)
print(f + Fraction(1, 2))

print(1 > 2, 1 < 2)
print(bool('spam'))
# x = None
# print(x)
L = [None] * 10
print(L)

print(type(L))
print(type(type(L)))

# if (type(L) == type([])):
#     print("yes")

if isinstance(L, list):
    print("yes")

if isinstance(L, list):
    print("yes")


class Worker:

    def __init__(self, name, pay):
        self.name = name
        self.pay = pay

    def lastName(self):
        return self.name.split()[-1]

    def giveRaise(self, percent):
        self.pay *= (1.0 + percent)


bob = Worker('Bob Smith', 50000)
sue = Worker('Sue Jones', 60000)
print(bob.lastName())
print(sue.lastName())
sue.giveRaise(0.10)
print(sue.pay)

print(hex(18))
print(oct(18))
print(bin(18))
print(int("FF", 16))

print(3 / 2)
print(3 // 2)

s = 'a\0b\0c'
print(s)
print(len(s))

s = '\001\002\x03'
print(s)
print(len(s))

s = 's\tp\na\x00m'
print(s)
print(len(s))

mantra = '''Always look
    on the bright
    side of life.
'''
print(mantra)

myjob = "hacker"
for c in myjob:
    print(c, end=" ")

print("")
print("k" in myjob)
print("z" in myjob)
print("spam" in "abcspamdef")

print(repr("a\0b\0c"))
print(str("a\0b\0c"))

print(ord('我'))
print(chr(25105))
# for i in range(25100, 25100 + 100):
#     print(chr(i))

B = '1101'
I = 0
while B != '':
    I = I * 2 + (ord(B[0]) - ord('0'))
    B = B[1:]

print(I)

print(int('1101', 2))
print(bin(13))

s = 'xxxxSPAMxxxxSPAMxxxx'
print(s.replace('SPAM', 'EGGS'))
print(s.replace('SPAM', 'EGGS', 1))

s = "spammy"
print(s)
l = list(s)
print(l)
l[3] = 'x'
l[4] = 'x'
print(l)
s = ''.join(l)
print(s)

line = "aaa bbb ccc"
print(line)
cols = line.split()
print(cols)

line = "The knights who say Ni!\n"
print(line)
print(line.rstrip())
print(line.upper())
print(line.isalpha())
print(line.endswith("Ni!\n"))
print(line.startswith("The"))

print(line)
print(line.find("Ni") != -1)
print("Ni" in line)
sub = "Ni!\n"
print(line.endswith(sub))
print(line[-len(sub):] == sub)

print(len([1, 2, 3]))
print([1, 2, 3] + [4, 5, 6])
print(["Ni!"] * 4)
print(str([1, 2]) + "34")
print([1, 2] + list("34"))

print(list(map(abs, [-1, -2, 0, 1, 2])))

L = ['spam', 'Spam', "SPAM!"]
print(L[2])
print(L[-2])
print(L[1:])

matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
print(matrix[1])
print(matrix[1][1])
print(matrix[2][0])

L = ['spam', 'Spam', "SPAM!"]
print(L)

L[1] = 'eggs'
print(L)

L[0:2] = ['eat', 'more', 'yes']
print(L)

L = [1, 2, 3]
print(L)
L[1:2] = [4, 5]
print(L)
L[1:1] = [6, 7]
print(L)
L[1:2] = []
print(L)

L = [1]
print(L)
L[:0] = [2, 3, 4]
print(L)
L[len(L):] = [5, 6, 7]
print(L)
L.extend([8, 9, 10])
print(L)

L = ['eat', 'more', 'SPAM!']
print(L)
L.append('please')
print(L)
L.sort()
print(L)

L = ['abc', 'ABD', 'aBe']
L.sort()
print(L)

L = ['abc', 'ABD', 'aBe']
L.sort(key=str.lower)
print(L)

L = ['abc', 'ABD', 'aBe']
L.sort(key=str.lower, reverse=True)
print(L)

L = ['abc', 'ABD', 'aBe']
print(sorted(L, key=str.lower, reverse=True))
print(L)

L = ['abc', 'ABD', 'aBe']
print(sorted([x.lower() for x in L], reverse=True))

L = [1, 2]
L.extend([3, 4, 5])
print(L)
L.pop()
print(L)
L.reverse()
print(L)
print(list(reversed(L)))

L = []
L.append(1)
L.append(2)
L.append(3)
print(L)
L.pop()
print(L)

L = ['spam', 'eggs', 'ham']
print(L.index('ham'))
L.insert(1, 'toast')
print(L)
L.remove('eggs')
print(L)
L.pop(1)
print(L)
print(L.count('spam'))

L = ['spam', 'eggs', 'ham', 'toast']
print(L)
del L[0]
# L[0] = []
print(L)
# del L[1:]
L[1:] = []
print(L)

L = ['Already', 'got', 'one']
L[1:] = []
print(L)
L[0] = []
print(L)

D = {'spam': 2, 'ham': 1, 'eggs': 3}
print(list(D.keys()))
print(list(D.values()))
print(list(D.items()))

# print(D['yes'])
print(D.get('yes', 0))
print(D.get('spam'))
print(D.get('toast'))
print(D.get('toast', 88))

D2 = {'toast': 4, 'muffin': 5}
print(D)
print(D2)
D.update(D2)
print(D)
print(D2)

# pop a dictionary by key
print('# pop a dictionary by key')
print(D)
print(D.pop('muffin'))
print(D.pop('toast'))
print(D)

# pop a list by position
print('pop a list by position')
L = ['aa', 'bb', 'cc', 'dd']
print(L.pop())
print(L)
print(L.pop(1))
print(L)
