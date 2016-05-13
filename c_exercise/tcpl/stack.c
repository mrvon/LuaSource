#include <stdio.h>
#include "calc.h"


extern int sp;
extern double val[];

void push(double f)
{
    if (sp < STACK_MAX_VAL) {
        val[sp++] = f;
    }
    else {
        printf("error: stack full, can't push %g\n", f);
    }
}

double pop(void)
{
    if (sp > 0) {
        return val[--sp];
    }
    else {
        printf("error: stack empty\n");
        return 0.0;
    }
}

