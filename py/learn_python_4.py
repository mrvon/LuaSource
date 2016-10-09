D = {
    'a': 1,
    'b': 2,
    'c': 3,
}

print(D)

ks = list(D.keys())
print(ks)

ks.sort()
print(ks)

for key in ks:
    print(key, "=>", D[key])

print(D)
for key in sorted(D):
    print(key, "=>", D[key])

for c in "spam":
    print(c.upper())

x = 10
while x > 0:
    print("spam!" * x)
    x -= 1

squares = [y ** 2 for y in [1, 2, 3, 4, 5]]
print(squares)

squares_2 = []
for x in [1, 2, 3, 4, 5]:
    squares_2.append(x ** 2)

print(squares_2)

T = (1, 2, 3, 4)
print(T)

T = T + (5, 6)
print(T)

print(T[0])
print(T[len(T) - 1])
print(T[:])

print(T.index(4))
print(T.count(4))

print(T)
T = (2, ) + T[1:]
print(T)

T = 'spam', 3.0, [11, 22, 33]
print(T)
print(T[0])
print(T[1])
print(T[2])
print(T[2][1])
# T.append(4)

f = open('data.txt', 'w')
f.write('hello\n')
f.write('world\n')
f.close()

f = open('data.txt')
text = f.read()
print(text)

print(text.split())

for line in open("data.txt"):
    print(line)

print("----------------------------------")

import struct


packed = struct.pack(">i4sh", 7, b"spam", 8)
print(packed)

file = open('data.bin', 'wb')
file.write(packed)
file.close()

print("----------------------------------")

s = "sp\xc4m"
print(s)
print(s[2])

file = open('unidata.txt', 'w', encoding='utf-8')
file.write(s)
file.close()

text = open('unidata.txt', encoding='utf-8').read()
print(text)
print(len(text))

raw = open('unidata.txt', 'rb').read()
print(raw)
print(len(raw))


print(text.encode('utf-8'))
print(raw.decode('utf-8'))
