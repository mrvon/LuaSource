import re

match = re.match("Hello[ \t]*(.*)world", "Hello     Python world")
print(match.groups())

match = re.match('[/:](.*)[/:](.*)[/:](.*)', '/use/home:lumberjack')
print(match.groups())

print(re.split("[/:]", "/usr/home:lumberjack"))

lst = [123, 'spam', 1.23]
lst.append("NI")
print(lst)

lst.pop(2)
print(lst)

lst.remove(123)
print(lst)

lst.extend(lst[:])
print(lst)

M = ['bb', 'aa', 'cc']
print(M)
M.sort()
print(M)
M.reverse()
print(M)

lst = [123, 'spam', "NI"]
# print(lst[99])
# lst[99] = 1
