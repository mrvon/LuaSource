%option noyywrap

%{
/* Lex program to convert uppercase to
   lowercase except inside comments
*/
#include <stdio.h>
#include <stdbool.h>
%}

%%
[A-Z] {
    putchar(tolower(yytext[0]));
    /* yytext[0] is the single uppercase char found */
}
"/*" {
    char c;
    int done = false;

    ECHO;

    do {
        while ((c = input()) != '*') {
            putchar(c);
        }
        putchar(c);
        while ((c = input()) == '*') {
            putchar(c);
        }
        putchar(c);
        if (c == '/') {
            done = true;
        }
    } while (!done);
}
%%

int main() {
    yylex();
    return 0;
}
