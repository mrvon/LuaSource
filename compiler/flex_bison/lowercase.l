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
        while (true) {
            c = input();

            if (c == EOF) {
                goto loop;
            }
            if (c != '*') {
                putchar(c);
            } else {
                break;
            }
        }
        putchar(c);
        while (true) {
            c = input();

            if (c == EOF) {
                goto loop;
            }
            if (c == '*') {
                putchar(c);
            } else {
                break;
            }
        }
        putchar(c);
        if (c == '/') {
            done = true;
        }
    } while (!done);

    loop:;
}
%%

int main() {
    yylex();
    return 0;
}
