#ifndef DCL_H
#define DCL_H

#define MAXTOKEN 100
#define MAXOUTPUT 1000

enum { NAME, PARENS, BRACKETS };

int getch(void);
void ungetch(int c);
int gettoken(void);

int tokentype;              /* type of last token */
char token[MAXTOKEN];       /* last token string */
char name[MAXTOKEN];        /* identifier name */
char datatype[MAXTOKEN];    /* data type = char, int, etc. */
char out[MAXOUTPUT];        /* output string */

#endif
