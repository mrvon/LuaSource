#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "calc.h"

int getop(char s[])
{
    int i;
    int c;

    while ((s[0] = c = getch()) == ' ' || c == '\t')
        ;

    s[1] = '\0';
    if (! isdigit(c) && c != '.' && c != '+' && c != '-') {
        return c;       /* not a number */
    }

    i = 0;

    if (c == '+' || c == '-') {
        int n = getch();
        if (n == EOF) {
            return c;
        }
        if (! isdigit(n) && n != '.') {
            ungetch(n);
            return c;
        }
        s[++i] = c = n;
    }

    if (isdigit(c)) {   /* collect integer part */
        while (isdigit(s[++i] = c = getch()))
            ;
    }
    if (c == '.') {     /* collect fraction part */
        while (isdigit(s[++i] = c = getch()))
            ;
    }
    s[i] = '\0';
    if (c != EOF) {
        ungetch(c);
    }

    return NUMBER;
}

