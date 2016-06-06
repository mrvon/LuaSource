%option noyywrap

%{
/* a Lex program that changes all numbers
   from decimal to hexadecimal notation,
   printing a summary statistic to stderr
*/
#include <stdio.h>
#include <stdlib.h>
int count = 0;
%}

digit [0-9]
number {digit}+

%%

{number} {
    int n = atoi(yytext);
    printf("%x", n);
    if (n > 9) {
        count++;
    }
}

%%

int main() {
    yylex();
    fprintf(stderr, "number of replacements = %d", count);
    return 0;
}
