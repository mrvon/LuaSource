#include <stdio.h>
#include <stdlib.h>
#include "calc.h"

#define MAXOP 100

int __main(int argc, char const* argv[])
{
    int type;
    char s[MAXOP];

    while((type = getop(s)) != EOF) {
        if (type == NUMBER) {
            printf("%s \t-> %lf\n", s, kr_atof(s));
        }
    }

    return 0;
}

int main(int argc, char const* argv[])
{
    int type;
    double op2;
    char s[MAXOP];

    while((type = getop(s)) != EOF) {
        switch (type) {
            case NUMBER:
                push(kr_atof(s));
                break;
            case '+':
                push(pop() + pop());
                break;
            case '*':
                push(pop() * pop());
                break;
            case '-':
                op2 = pop();
                push(pop() - op2);
                break;
            case '/':
                op2 = pop();
                if (op2 != 0.0)
                    push(pop() / op2);
                else
                    printf("error: zero divisor\n");
                break;
            case '%':
                op2 = pop();
                if (op2 != 0.0)
                    push((int)pop() % (int)op2);
                else
                    printf("error: zero modulus\n");
                break;
            case '\n':
                printf("\t%.8g\n", pop());
                break;
            default:
                printf("error: unknown command %s\n", s);
                break;
        }
    }
    return 0;
}
