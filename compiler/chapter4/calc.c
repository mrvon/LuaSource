/* Simple integer arithmetic calculator
   according to the EBNF:
 
   <exp>    -> <term> { <addop> <term> }
   <addop>  -> + | -
   <term>   -> <factor> { <mulop> <factor> }
   <mulop>  -> *
   <factor> -> ( <exp> ) | Number

   Inputs a line of text from stdin
   Outputs "Error" or the result.__amd64
*/

#include <stdio.h>
#include <stdlib.h>


char token; /* global token variable */

/* function prototypes for recursive calls */
int lexp();
int lterm();
int lfactor();

void error() {
    fprintf(stderr, "Error\n");
    exit(1);
}

void match(char expectedToken) {
    if (token == expectedToken) {
        token = getchar();
    } else {
        error();
    }
}

int lexp() {
    int temp = lterm();

    while ((token == '+') || (token == '-')) {
        switch (token) {
            case '+': {
                match('+');
                temp += lterm();
                break;
            }
            case '-': {
                match('-');
                temp -= lterm();
                break;
            }
        }
    }

    return temp;
}

int lterm() {
    int temp = lfactor();

    while (token == '*') {
        match('*');
        temp *= lfactor();
    }

    return temp;
}

int lfactor() {
    int temp;

    if (token == '(') {
        match('(');
        temp = lexp();
        match(')');
    } else if (isdigit(token)) {
        ungetc(token, stdin);
        scanf("%d", &temp);
        token = getchar();
    } else {
        error();
    }

    return temp;
}

int main() {
    int result;

    /* load token with first character for lookahead */
    token = getchar();

    result = lexp();

    if (token == '\n') {
        /* check for end of line */
        printf("Result = %d\n", result);
    } else {
        /* extraneous chars on line */
        error();
    }

    return 0;
}
