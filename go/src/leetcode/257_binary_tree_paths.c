/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     struct TreeNode *left;
 *     struct TreeNode *right;
 * };
 */
/**
 * Return an array of size *returnSize.
 * Note: The returned array must be malloced, assume caller calls free().
 */

struct StringArray {
    char** arr;
    int asize;
    int a;
    char* cur;
    int csize;
    int c;
    char buff[1000];
};

void __init_sa(struct StringArray* sa) {
    sa->asize = 100;
    sa->arr = malloc(sizeof(char*) * sa->asize);
    sa->a = 0;
    sa->csize = 100;
    sa->cur = malloc(sizeof(char) * sa->csize);
    sa->c = 0;
}

void __push_char(struct StringArray* sa, char c) {
    if (sa->c >= sa->csize) {
        sa->csize = sa->csize * 2;
        sa->cur = realloc(sa->cur, sa->csize);
    }
    sa->cur[sa->c++] = c;
}

void __pop_char(struct StringArray* sa) {
    if (sa->c == 0) {
        printf("can't pop empty string.");
    }
    sa->c--;
}

void __push_int(struct StringArray* sa, int i) {
    int n = sprintf(sa->buff, "%d", i);
    for (int i = 0; i < n; i++) {
        __push_char(sa, sa->buff[i]);
    }
}

void __pop_int(struct StringArray* sa) {
    for (int i = sa->c; i > 0; i--) {
        if (sa->cur[i-1] != '>') {
            __pop_char(sa);
        } else {
            break;
        }
    }
}

void __push_curr(struct StringArray* sa) {
    if (sa->a >= sa->asize) {
        sa->asize = sa->asize * 2;
        sa->arr = realloc(sa->arr, sa->asize);
    }
    char* cpy = malloc(sizeof(char) * (sa->c + 1));
    for (int i = 0; i < sa->c; i++) {
        cpy[i] = sa->cur[i];
    }
    cpy[sa->c] = '\0';
    sa->arr[sa->a++] = cpy;
}

void __binaryTreePaths(struct TreeNode* root, struct StringArray* sa) {
    if (root == NULL) {
        return;
    }
    
    __push_int(sa, root->val);
    
    if (root->left == NULL && root->right == NULL) {
        __push_curr(sa);
        __pop_int(sa);
        return;
    }
    
    __push_char(sa, '-');
    __push_char(sa, '>');
    
    __binaryTreePaths(root->left, sa);
    __binaryTreePaths(root->right, sa);
    
    __pop_char(sa);
    __pop_char(sa);
    __pop_int(sa);
}

char** binaryTreePaths(struct TreeNode* root, int* returnSize) {
    struct StringArray sa;
    __init_sa(&sa);
    
    __binaryTreePaths(root, &sa);
    
    *returnSize = sa.a;
    return sa.arr;
}
