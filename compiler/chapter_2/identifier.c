#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>
#include <assert.h>

#define OK 0
#define ERR 1

int read_identifier() {
    char c;
    int state = 1;

    while (state == 1 || state == 2) {
        switch (state) {
            case 1: {
                c = getchar();
                if (c == EOF) {
                    return EOF;
                }

                if (isalpha(c)) {
                    putchar(c);
                    state = 2;
                } else {
                    printf("HEX(%x)", c);
                    return ERR;
                }
            }
            case 2: {
                c = getchar();
                if (c == EOF) {
                    return EOF;
                }

                if (isalpha(c) || isdigit(c)) {
                    putchar(c);
                    state = 2;
                } else {
                    state = 3;
                }
            }
            break;
        };
    };

    assert(state == 3);

    return OK;
}

int main() {
    while (true) {
        int r = read_identifier();

        if (r == EOF) {
            break;
        } else if (r == OK) {
            printf("%s\n", " Is a identify");
        } else {
            printf("%s\n", " Is not a identify");
        }
    }

    return 0;
}
