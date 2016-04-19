#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#define RED     0
#define BLACK   1

struct rb_node {
    int key;
    int val;
    int color;

    struct rb_node* parent;
    struct rb_node* left_child;
    struct rb_node* right_child;
};

struct rb_tree {
    struct rb_node* root_node;
    size_t size;
};

static struct rb_node nil_node = {
    0, 0, BLACK, NULL, NULL, NULL
};

#define NIL_NODE (&nil_node)

static struct rb_node*
new_node() {
    struct rb_node* node = (struct rb_node*)malloc(sizeof(*node));
    assert(node);

    node->color         = RED;
    node->left_child    = NIL_NODE;
    node->right_child   = NIL_NODE;
    node->parent        = NIL_NODE;

    return node;
}

static struct rb_tree* 
new_rb_tree() {
    struct rb_tree* tree = (struct rb_tree*)malloc(sizeof(*tree));
    assert(tree);

    tree->root_node = NIL_NODE;
    tree->size = 0;

    return tree;
}

static void 
del_rb_tree(struct rb_tree* tree) {
}

static struct rb_node*
__search(struct rb_tree* tree, struct rb_node* node, int search_key) {
    if (node == NIL_NODE || node->key == search_key) {
        return node;
    }

    if (search_key < node->key) {
        return __search(tree, node->left_child, search_key);
    } else {
        return __search(tree, node->right_child, search_key);
    }
}

static int
search(struct rb_tree* tree, int search_key) {
    struct rb_node* node = __search(tree, tree->root_node, search_key);
    if (node == NIL_NODE) {
        return 0;
    } else {
        return node->val;
    }
}

static void
left_rotate(struct rb_tree* tree, struct rb_node* x) {
    struct rb_node* y = x->right_child;      // Set y
    x->right_child = y->left_child;          // Turn y's left subtree into x's right subtree

    if (y->left_child != NIL_NODE) {
        y->left_child->parent = x;
    }

    y->parent = x->parent;                   // Link x's parent to y

    if (x->parent == NIL_NODE) {
        tree->root_node = y;
    } else if (x == x->parent->left_child) {
        x->parent->left_child = y;
    } else {
        x->parent->right_child = y;
    }

    y->left_child = x;                       // Put x on y's left
    x->parent = y;
}

static void
right_rotate(struct rb_tree* tree, struct rb_node* y) {
    struct rb_node* x = y->left_child;       // Set x
    y->left_child = x->right_child;          // Turn x's right subtree into y's left subtree

    if (x->right_child != NIL_NODE) {
        x->right_child->parent = y;
    }

    x->parent = y->parent;                   // Link y's parent to x

    if (y->parent == NIL_NODE) {
        tree->root_node = x;
    } else if (y == y->parent->left_child) {
        y->parent->left_child = x;
    } else {
        y->parent->right_child = x;
    }

    x->right_child = y;                      // Put y on x's right
    y->parent = x;
}

static void 
insert_fixup(struct rb_tree* tree, struct rb_node* z) {
    while (z->parent->color == RED) {
        if (z->parent == z->parent->parent->left_child) {
            struct rb_node* y = z->parent->parent->right_child;
            if (y->color == RED) {
                z->parent->color = BLACK;                      // CASE 1
                y->color = BLACK;                              // CASE 1
                z->parent->parent->color = RED;                // CASE 1
                z = z->parent->parent;                         // CASE 1
            } else {
                if (z == z->parent->right_child) {
                    z = z->parent;                             // CASE 2
                    left_rotate(tree, z);                      // CASE 2
                }
                z->parent->color = BLACK;                      // CASE 3
                z->parent->parent->color = RED;                // CASE 3
                right_rotate(tree, z->parent->parent);         // CASE 3
            }
        } else {
            struct rb_node* y = z->parent->parent->left_child;

            if (y->color == RED) {
                z->parent->color = BLACK;                      // CASE 1
                y->color = BLACK;                              // CASE 1
                z->parent->parent->color = RED;                // CASE 1
                z = z->parent->parent;                         // CASE 1
            } else {
                if (z == z->parent->left_child) {
                    z = z->parent;                             // CASE 2
                    right_rotate(tree, z);                     // CASE 2
                }
                z->parent->color = BLACK;                      // CASE 3
                z->parent->parent->color = RED;                // CASE 3
                left_rotate(tree, z->parent->parent);          // CASE 3
            }
        }
    }

    tree->root_node->color = BLACK;
}

static void
__insert(struct rb_tree* tree, int insert_key, int insert_val) {
    struct rb_node* x = tree->root_node;
    struct rb_node* y = NIL_NODE;            // trailing pointer of x
    struct rb_node* z = new_node();

    tree->size++;

    z->key = insert_key;
    z->val = insert_val;

    while(x != NIL_NODE) {
        y = x;

        if(z->key < x->key) {
            x = x->left_child;
        } else {
            x = x->right_child;
        }
    }

    z->parent = y;

    if(y == NIL_NODE) {
        tree->root_node = z;
    } else if(z->key < y->key) {
        y->left_child = z;
    } else {
        y->right_child = z;
    }

    insert_fixup(tree, z);
}

static void
insert(struct rb_tree* tree, int insert_key, int insert_val) {
    struct rb_node* node = __search(tree, tree->root_node, insert_key);
    if (node == NIL_NODE) {
        __insert(tree, insert_key, insert_val);
    }
}

static void
delete(struct rb_tree* tree, int delete_key) {
}

static void
__delete() {
}

int main() {
    struct rb_tree* tree = new_rb_tree();

    int m = 10;
    int i = 1;
    for (i = 1; i < m; ++i) {
        insert(tree, i, i * 3);
    }

    for (i = 1; i < m; ++i) {
        assert(search(tree, i) == (i * 3));
    }

    del_rb_tree(tree);

    return 0;
}
