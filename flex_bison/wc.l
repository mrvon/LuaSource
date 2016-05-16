/* just like Unix wc */
%{
    int chars = 0;
    int words = 0;
    int lines = 0;
%}

%%

[^ \t\n\r\f\v]+ { words++; chars += strlen(yytext); }
\n              { chars++; lines++; }
.               { chars++; }

%%

int main(int argc, char **argv) {
    yylex();
    printf("line:%8d\nword:%8d\nchar:%8d\n", lines, words, chars);
    return 0;
}
