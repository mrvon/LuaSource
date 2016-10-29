#include <stdio.h>

char findTheDifference(char* s, char* t) {
    int  i;
    char c;
    char x[26] = {0};
    char y[26] = {0};

    while ((c=*s++)) {
        x[c-'a'] += 1;
    }

    while ((c=*t++)) {
        y[c-'a'] += 1;
    }

    for (i = 0; i < 26; i++) {
        if (x[i] != y[i]) {
            return 'a'+i;
        }
    }

    // should not be here.
    return 0;
}

int main() {
    printf("%c\n", findTheDifference("abcd", "abecd"));
    return 0;
}
