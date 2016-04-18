#include <stdio.h>

int kr_getline(char line[], int max_line)
{
    int i;
    int c;

    for (i = 0; i < max_line - 1 && (c = getchar()) != EOF && c != '\n'; ++i)
        line[i] = c;
    if (c == '\n')
        line[i++] = c;
    line[i] ='\0';
    return i;
}
