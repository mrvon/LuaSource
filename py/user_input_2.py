#!/usr/bin/python
# Filename: user_input_2.py


def reverse(text):
    return text[::-1]


def is_palindrome(text):
    return text == reverse(text)


def clean_str(input_str):
    new_str = ""
    for char in input_str:
        if char.isalpha():
            new_str += char.lower()
    return new_str

something = clean_str(input("Enter text:"))
print(something)

if is_palindrome(something):
    print("Yes, it is a palindrome")
else:
    print("No, it is not a palindrome")
