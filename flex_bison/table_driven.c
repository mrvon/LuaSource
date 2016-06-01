#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>
#include <assert.h>

#define OK 0
#define ERR 1

int read_identifier() {
    return OK;
}

int read_c_comment() {
    const int SLASH = 0;
    const int STAR  = 1;
    const int OTHER = 2;

    static int Accept[6] = {
        0,  // no accept
        0,  // state 1
        0,  // state 2
        0,  // state 3
        0,  // state 4
        1,  // state 5
    };

    static int Error[6] = {
        1,  // state error
        0,  // state 1
        0,  // state 2
        0,  // state 3
        0,  // state 4
        0,  // state 5
    };

    static int Advance[6][3] = {
        {0, 0, 0}, // dummy
        {1, 1, 1}, // state 1
        {1, 1, 1}, // state 2
        {1, 1, 1}, // state 3
        {1, 1, 1}, // state 4
        {1, 1, 1}, // state 5
    };

    static int T[6][3] = {
        {0, 0, 0}, // dummy
        {2, 0, 0}, // state 1
        {0, 3, 0}, // state 2
        {3, 4, 3}, // state 3
        {5, 4, 3}, // state 4
        {0, 0, 0}, // state 5
    };

    char c;
    int state = 1;

    c = getchar();
    putchar(c);

    while (! Accept[state] && ! Error[state]) {
        int t;
        if (c == '/') {
            t = SLASH;
        } else if (c == '*') {
            t = STAR;
        } else {
            t = OTHER;
        }

        int new_state = T[state][t];

        assert(Advance[state][t]);

        if (Advance[state][t]) {
            c = getchar();
            putchar(c);
        }

        state = new_state;
    }

    if (Accept[state]) {
        return OK;
    } else {
        return ERR;
    }
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

