temp_str = "shrubbery"
temp_list = list(temp_str)

print(temp_str)
print(temp_list)

temp_list[1] = 'c'
print("".join(temp_list))

b = bytearray(b'spam')
b.extend(b'eggs')
print(b)
print(b.decode())

temp_str = 'Spam'
print(temp_str.find('pa'))
print(temp_str.find('h'))
print(temp_str)
print(temp_str.replace('pa', 'XYZ'))
print(temp_str)

line = "aaa,bbb,ccccc,dd"
print(line)
print(line.split(","))

print(temp_str.upper())
print(temp_str.lower())
print(temp_str.isalpha())

line = "aaa,bbb,ccccc,dd\n"
print(line.rstrip())
print(line.rstrip().split(","))
print("-".join(line.rstrip().split(",")))
print(line.replace(",", "-"))

print("{0} {1}".format(1, 4))

print("%s, eggs, and %s" % ("spam", "SPAM!"))
print("{0}, eggs, and {1}".format("spam", "SPAM!"))
print("{}, eggs, and {}".format("spam", "SPAM!"))

print("{:,.2f}".format(296999.2567))
print("{:.1f}".format(296999.2567))

print("%.2f | %+05d" % (3.14159, -42))
print("{:.1f}".format(3.14159))

string = "A\nB\tC"
print(len(string))
print(string)

print(ord("\n"))
string = "A\0B\0C"
print(len(string))
print(string)

print(r"C:\text\new")
print("C:\\text\\new")

print('sp\xc4m')
print(b'a\x01c')
print(u'sp\u00c4m')

print("我们".encode('utf8'))
print("我们".encode('utf16'))
print(b'\xe6\x88\x91\xe4\xbb\xac'.decode('utf8'))
print(b'\xff\xfe\x11b\xecN'.decode('utf16'))

print('sp' + '\xc4\u00c4\U000000c4' + 'm')
print('\u00A3', '\u00A3'.encode('latin1'), b'\xA3'.decode('latin1'))

print(u'x' + 'y')
print('x' + b'y'.decode())
print(('x'.encode() + b'y').decode())

encoding = "旧的".encode()
text = encoding.decode()
print(encoding)
print(text)
