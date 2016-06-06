%option noyywrap

%{
/* Selects only lines that end or
   begin with the letter 'a'.
   Deletes everything else.
*/
#include <stdio.h>
%}

ends_with_a .*a\n
start_with_a a.*\n

%%
{ends_with_a}   { ECHO; }
{start_with_a}  { ECHO; }
.*\n            { }
%%

int main() {
    yylex();
    return 0;
}
