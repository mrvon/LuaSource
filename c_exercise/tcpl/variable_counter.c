#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include "calc.h"
#include "tree.h"

#define MAXWORD 100

int binsearch(char* str, const char** set, int n);

const char* keyword_set[] = {
    "auto"     ,
    "break"    ,
    "case"     ,
    "char"     ,
    "const"    ,
    "continue" ,
    "default"  ,
    "do"       ,
    "double"   ,
    "else"     ,
    "enum"     ,
    "extern"   ,
    "float"    ,
    "for"      ,
    "goto"     ,
    "if"       ,
    "int"      ,
    "long"     ,
    "register" ,
    "return"   ,
    "short"    ,
    "signed"   ,
    "sizeof"   ,
    "static"   ,
    "struct"   ,
    "switch"   ,
    "typedef"  ,
    "union"    ,
    "unsigned" ,
    "void"     ,
    "volatile" ,
    "while"    ,
};

#define NKEYS (sizeof(keyword_set) / sizeof(keyword_set[0]))

int main(int argc, char const* argv[])
{
    tnode* root;
    int n;
    char word[MAXWORD];

    root = NULL;

    while (getword(word, MAXWORD) != EOF) {
        if (isalpha(word[0])) {
            if ((n = binsearch(word, keyword_set, NKEYS)) == -1) {
                root = addtree(root, word);
            }
        }
    }
    treeprint(root);

    return 0;
}

int binsearch(char* str, const char** set, int n)
{
    int low = 0;
    int high = n - 1;
    int mid;
    int cond;

    while (low <= high) {
        mid = (low + high) / 2;
        cond = strcmp(str, set[mid]);
        if (cond < 0) {
            high = mid - 1;
        }
        else if (cond > 0) {
            low = mid + 1;
        }
        else {
            return mid;
        }
    }

    return -1;
}
