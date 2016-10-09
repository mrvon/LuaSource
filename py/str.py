old_str = "Hello world from mrvon"
str_list = []

print(old_str)

for i in range(0, len(old_str)):
    str_list.append(old_str[i])

print(str_list)

for i in range(0, len(str_list)):
    if str_list[i] == " ":
        str_list[i] = "_"

print(str_list)

new_str = "".join(str_list)

print(new_str)
