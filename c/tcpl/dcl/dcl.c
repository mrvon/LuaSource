#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "dcl.h"


void dcl(void);
void dirdcl(void);


/* convert declaration to words */
int main(int argc, char const* argv[])
{
    while (gettoken() != EOF) {     /* 1st token on line */
        strcpy(datatype, token);    /* is the datatype */
        out[0] = '\0';
        dcl();  /* parse rest of line */
        if (tokentype != '\n')
            printf("syntax error\n");
        printf("%s: %s %s\n", name, out, datatype);
    }
    return 0;
}

/* dcl: parse a declarator */
void dcl(void)
{
    int ns;

    for (ns = 0; gettoken() == '*'; )
        ns++;
    dirdcl();
    while (ns-- > 0)
        strcat(out, " pointer to");
}

/* dirdcl: parse a direct declarator */
void dirdcl(void)
{
    int type;

    if (tokentype == '(') {
        dcl();
        if (tokentype != ')') {
            printf("error: missing )\n");
        }
    }
    else if (tokentype == NAME) {
        strcpy(name, token);
    }
    else {
        printf("error: excepted name or {dcl}\n");
    }

    while ((type = gettoken()) == PARENS || type == BRACKETS) {
        if (type == PARENS) {
            strcat(out, " function returning");
        }
        else {
            strcat(out, " array");
            strcat(out, token);
            strcat(out, " of");
        }
    }
}
