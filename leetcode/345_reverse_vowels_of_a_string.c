#include <stdio.h>
#include <string.h>
#include <stdbool.h>

bool is_vowel(char c) {
    if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' ||
            c == 'A' || c == 'E' || c == 'I' || c == 'O' || c == 'U') {
        return true;
    } else {
        return false;
    }
}

char* reverseVowels(char* s) {
    char* b = s;
    char* e = b + strlen(s) - 1;

    while (true) {
        while (b < e) {
            if (! is_vowel(*b)) {
                b++;
            } else {
                break;
            }
        }

        while (b < e) {
            if (! is_vowel(*e)) {
                e--;
            } else {
                break;
            }
        }

        if (b < e) {
            char temp = *b;
            *b = *e;
            *e = temp;
            b++;
            e--;
        } else {
            break;
        }
    }
    return s;
}

int main() {
    char str[] = "hello";
    printf("%s\n", reverseVowels(str));
}
