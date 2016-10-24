#include <stdio.h>

int titleToNumber(char* s) {
    char c;
    int n = 0;

    while ((c = *s++)) {
        n *= 26;
        n += (c-'A'+1);
    }

    return n;
}

int main() {
    printf("%d\n", titleToNumber("A"));
    printf("%d\n", titleToNumber("Z"));
    printf("%d\n", titleToNumber("AA"));
    printf("%d\n", titleToNumber("AB"));
    printf("%d\n", titleToNumber("AAA"));
}
