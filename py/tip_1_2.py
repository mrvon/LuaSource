def drop_first_last(record):
    first, *middle, last = record
    # print(first)
    # print(middle)
    # print(last)

# record = ("Dave", "dave@example.com", "773-555-1212", "847-555-1212")
record = ("Dave", "dave@example.com")

name, email, *phone_numbers = record
# print(name)
# print(email)
# print(phone_numbers)

*trailing, current = [10, 8, 7, 1, 9, 5, 10, 3]
# print(trailing)
# print(current)

*head, tail = "Hello world"
# print(head)
# print("".join(head))
# print(tail)

records = [
    ('foo', 1, 2),
    ('bar', 'hello'),
    ('foo', 3, 4),
]
print(records)


def do_foo(x, y):
    print("foo", x, y)


def do_bar(s):
    print("bar", s)


for tag, *args in records:
    if tag == "foo":
        do_foo(*args)
    else:
        do_bar(*args)

line = "nobody:*:-2:-2:Unprivileged User:/var/empty:/usr/bin/false"
uname, *fields, homedir, sh = line.split(":")
# print(uname)
# print(fields)
# print(homedir)
# print(sh)

record = ("ACME", 50, 123.45, (12, 18, 2012))
name, *_, (*_, year) = record
# print(name)
# print(year)

items = [1, 10, 7, 4, 5, 9]
head, *tail = items
# print(head)
# print(*tail)
# print(tail)
print(items)
print(*items)


def sum(items):
    head, *tail = items
    return head * sum(tail) if tail else head


print(sum(items))
