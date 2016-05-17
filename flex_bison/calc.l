/* recognize takens for the calculator and print them out */

%{
#include "calc_parser.h"
%}

%%

"+"         { return ADD; }
"-"         { return SUB; }
"*"         { return MUL; }
"/"         { return DIV; }
"|"         { return ABS; }
[0-9]+      { yylval = atoi(yytext); return NUMBER; }
0x[a-f0-9]+ { yylval = strtol(yytext, NULL, 16); return NUMBER; }
"("         { return OP; }
")"         { return CP; }
"//".*      { /* ignore comments */ }
\n          { return EOL; }
[ \t]       { /* ignore whitespace */ }
.           { printf("Mystery character %c\n", *yytext); }

%%
