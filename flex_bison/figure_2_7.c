#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>
#include <assert.h>

#define OK 0
#define ERR 1

int read_c_comment() {
    char c;
    int state = 1;

    while (state == 1 || state == 2 || state == 3 || state == 4) {
        switch (state) {
            case 1: {
                c = getchar();
                if (c == EOF) {
                    return EOF;
                }

                if (c == '/') {
                    putchar(c);
                    state = 2;
                }
                else {
                    printf("HEX(%x)", c);
                    return ERR;
                }
            }
            case 2: {
                c = getchar();
                if (c == EOF) {
                    return EOF;
                }

                if (c == '*') {
                    putchar(c);
                    state = 3;
                } else {
                    printf("HEX(%x)", c);
                    return ERR;
                }
            }
            break;
            case 3: {
                c = getchar();
                if (c == EOF) {
                    return EOF;
                }

                if (c == '*') {
                    putchar(c);
                    state = 4;
                } else {
                    // State in state 3
                    putchar(c);
                }
            }
            break;
            case 4: {
                c = getchar();
                if (c == EOF) {
                    return EOF;
                }

                if (c == '/') {
                    putchar(c);
                    state = 5;
                } else if (c == '*') {
                    // State in state 4
                    putchar(c);
                } else {
                    putchar(c);
                    state = 3;
                }
            }
            break;
        };
    };

    assert(state == 5);
    return OK;
}

int main() {
    while (true) {
        int r = read_c_comment();

        if (r == EOF) {
            break;
        } else if (r == OK) {
            printf("%s\n", " Is a c comment");
        } else {
            printf("%s\n", " Is not a c comment");
        }
    }

    return 0;
}
