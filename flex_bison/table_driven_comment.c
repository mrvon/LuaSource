#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>
#include <assert.h>

#define OK 0
#define ERR 1

const int BUF_SIZE = 1024;
static int g_write_point = 0;
static char g_output_buffer[BUF_SIZE] = {0};

void reset_buffer() {
    g_write_point = 0;
    memset(g_output_buffer, 0, sizeof(g_output_buffer));
}

void push_char(char c) {
    assert(g_write_point < BUF_SIZE);
    g_output_buffer[g_write_point] = c;
    g_write_point++;
}

void push_string(const char* str) {
    while (*str != EOF) {
        g_output_buffer[g_write_point] = *str;
        str++;
        g_write_point++;
    }
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
        {1, 0, 0}, // state 1
        {0, 1, 0}, // state 2
        {1, 1, 1}, // state 3
        {1, 1, 1}, // state 4
        {0, 0, 0}, // state 5
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
    if (c == EOF) {
        return EOF;
    }

    push_char(c);

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

        printf("State(%d) -> State(%d)\n", state, new_state);

        if (Advance[state][t]) {
            c = getchar();
            if (c == EOF) {
                return EOF;
            }

            push_char(c);
        }

        state = new_state;
    }

    if (Accept[state]) {
        return OK;
    } else {
        return ERR;
    }
}

void test_comment() {
    while (true) {
        reset_buffer();

        int r = read_c_comment();

        if (r == EOF) {
            break;
        } else if (r == OK) {
            push_string(" Is a c comment");
            printf("%s\n", g_output_buffer);
        } else {
            push_string(" Isn't a c comment");
            printf("%s\n", g_output_buffer);
        }
    }
}

int main() {
    test_comment();
    return 0;
}
