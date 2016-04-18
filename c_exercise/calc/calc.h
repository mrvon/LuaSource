#ifndef CALC_H
#define CALC_H

#define NUMBER          '0'
#define STACK_MAX_VAL   100

int getop(char []);
void push(double);
double pop(void);
double kr_atof(char s[]);
int getch(void);
void ungetch(int);
int kr_getline(char line[], int max_line);
char *alloc(int n);
void afree(char *p);
int getword(char*, int);

#endif
