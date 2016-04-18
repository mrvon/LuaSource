#include <stdio.h>
#include <ctype.h>
#include "calc.h"

#define SIZE 1024

int getint(int *pn)
{
    int c;
    int sign;

    while (isspace(c = getch())) /* skip white space */
        ;
    if (! isdigit(c) && c != EOF && c != '+' && c != '-') {
        ungetch(c);
        return 0;
    }
    sign = (c == '-') ? -1 : 1;
    if (c == '+' || c == '-') {
        int n = getch();
        if (n == EOF || ! isdigit(n)) {
            ungetch(n);
            ungetch(c);
            return 0;
        }
        c = n;
    }
    for ((*pn) = 0; isdigit(c); c = getch()) {
        (*pn) = 10 * (*pn) + (c - '0');
    }
    (*pn) *= sign;
    if (c != EOF)
        ungetch(c);
    return c;
}

int main(int argc, char const* argv[])
{
    int n;
    int array[SIZE];
    for (n = 0; n < SIZE && getint(&array[n]) != EOF; n++) {
        printf("%d\n", array[n]);
    }

    return 0;
}
