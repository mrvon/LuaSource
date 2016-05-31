#include <stdio.h>
#include <ctype.h>
#include "calc.h"

int getword(char* word, int lim)
{
    int c;
    char* w = word;

    while (isspace(c = getch()))
        ;

    if (c == '/') {
        if ((c = getch()) && c == '*') {
            while (1) {
                while ((c = getch()) != EOF && c != '*')
                    ;
                if (c != EOF) {
                    c = getch();
                    if (c == '/') {
                        c = getch();
                        break;
                    }
                }
                else {
                    ungetch(c);
                }
            }
        }
        else {
            ungetch(c);
            c = '/';
        }
    }
    if (c == '/') {
        if ((c = getch()) && c == '/') {
            while ((c = getch()) != EOF && c != '\n')
                ;
            if (c != EOF) {
                c = getch();
            }
        }
    }
    if (c == '\"') {
        while ((c = getch()) != EOF && c != '\"')
            ;
        if (c != EOF) {
            c = getch();
        }
    }
    if (c != EOF) {
        *w++ = c;
    }
    if (! isalpha(c) && c != '_') {
        *w = '\0';
        return c;
    }
    for (; --lim > 0; w++) {
        if (! isalnum(*w = getch()) && *w != '_') {
            ungetch(*w);
            break;
        }
    }
    *w = '\0';
    return word[0];
}
