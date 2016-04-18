#include <stdio.h>
#include <string.h>
#include "calc.h"

#define MAXLINE 1000

int main(int argc, char const* argv[])
{
    char line[MAXLINE];
    long lineno = 0;
    int c;
    int except = 0;
    int number = 0;
    int found = 0;

    while (--argc > 0 && (*++argv)[0] == '-') {
        while (c = *++argv[0]) {
            switch (c) {
                case 'x':
                    except = 1;
                    break;
                case 'n':
                    number = 1;
                    break;
                default:
                    printf("find: illegal option %c\n", c);
                    argc = 0;
                    found = -1;
                    break;
            }
        }
    }

    if (argc != 1) {
        printf("Usage: find -x -n pattern\n");
    }
    else {
        while (kr_getline(line, MAXLINE) > 0) {
            lineno++;
            if ((strstr(line, *argv) != NULL) != except) {
                if (number) {
                    printf("%ld:", lineno);
                }
                printf("%s", line);
                found++;
            }
        }
    }

    return found;
}
