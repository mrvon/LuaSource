#ifndef TREE_H
#define TREE_H

typedef struct tnode {
    char* word;
    int count;
    struct tnode* left;
    struct tnode* right;
} tnode;

tnode* addtree(tnode* p, char* w);
void treeprint(tnode* p);
char* kr_strdup(char* s);

#endif
