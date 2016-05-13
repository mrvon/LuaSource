#include <stdio.h>
#include <ctype.h>
#include "calc.h"
#include "tree.h"

#define MAXWORD 100


int main(int argc, char const* argv[])
{
    tnode* root;
    char word[MAXWORD];

    root = NULL;

    while (getword(word, MAXWORD) != EOF) {
        if (isalpha(word[0])) {
            root = addtree(root, word);
        }
    }
    treeprint(root);
    return 0;
}

