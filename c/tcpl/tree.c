#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tree.h"

tnode* addtree(tnode* p, char* w)
{
    int cond;

    if (p == NULL) {
        p = (tnode*) malloc(sizeof(tnode));
        p->word = kr_strdup(w);
        p->count = 1;
        p->left = NULL;
        p->right = NULL;
    }
    else if ((cond = strcmp(w, p->word)) == 0) {
        p->count++;
    }
    else if (cond < 0) {
        p->left = addtree(p->left, w);
    }
    else {
        p->right = addtree(p->right, w);
    }

    return p;
}

void treeprint(tnode* p)
{
    if (p != NULL) {
        treeprint(p->left);
        printf("%4d %s\n", p->count, p->word);
        treeprint(p->right);
    }
}

char* kr_strdup(char* s)
{
    char* p;

    p = (char*) malloc(strlen(s) + 1);
    if (p != NULL) {
        strcpy(p, s);
    }
    return p;
}
