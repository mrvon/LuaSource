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
    0
};

#define NIL_NODE (&nil_node)

static void
global_init() {
    nil_node.color          = BLACK;
    nil_node.parent         = NIL_NODE;
    nil_node.left_child     = NIL_NODE;
    nil_node.right_child    = NIL_NODE;
}

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

static void
del_node(struct rb_node* node) {
    assert(node);
    free((void*)node);
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
__make_empty(struct rb_node* node) {
    if (node != NIL_NODE) {
        __make_empty(node->left_child);
        __make_empty(node->right_child);
        del_node(node);
    }
}

static void
make_empty(struct rb_tree* tree) {
    __make_empty(tree->root_node);

    tree->root_node = NIL_NODE;
    tree->size = 0;
}

static void 
del_rb_tree(struct rb_tree* tree) {
    assert(tree);
    make_empty(tree);
    free((void*)tree);
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

static struct rb_node*
minimum(struct rb_node* x) {
    while (x->left_child != NIL_NODE) {
        x = x->left_child;
    }
    return x;
}

static struct rb_node*
maximum(struct rb_node* x) {
    while (x->right_child != NIL_NODE) {
        x = x->right_child;
    }
    return x;
}

static struct rb_node*
predecessor(struct rb_node* x) {
    if (x->left_child != NIL_NODE) {
        return maximum(x->left_child);
    }

    struct rb_node* y = x->parent;

    while (y != NIL_NODE && x == y->left_child) {
        x = y;
        y = y->parent;
    }

    return y;
}

static struct rb_node*
successor(struct rb_node* x) {
    if (x->right_child != NIL_NODE) {
        return minimum(x->right_child);
    }

    struct rb_node* y = x->parent;

    while (y != NIL_NODE && x == y->right_child) {
        x = y;
        y = y->parent;
    }
    return y;
}

static void
transplant(struct rb_tree* tree, struct rb_node* u, struct rb_node* v) {
    if (u->parent == NIL_NODE) {
        tree->root_node = v;
    } else if (u == u->parent->left_child) {
        u->parent->left_child = v;
    } else {
        u->parent->right_child = v;
    }
    v->parent = u->parent;
}

static void
delete_fixup(struct rb_tree* tree, struct rb_node* x) {
    while (x != tree->root_node && x->color == BLACK) {
        if (x == x->parent->left_child) {
            struct rb_node* w = x->parent->right_child;

            if (w->color == RED) {
                w->color = BLACK;                                                  // CASE 1
                x->parent->color = RED;                                            // CASE 1
                left_rotate(tree, x->parent);                                      // CASE 1
                w = x->parent->right_child;                                        // CASE 1
            }

            if (w->left_child->color == BLACK && w->right_child->color == BLACK) {
                w->color = RED;                                                    // CASE 2
                x = x->parent;                                                     // CASE 2
            } else {
                if (w->right_child->color == BLACK) {
                    w->left_child->color = BLACK;                                  // CASE 3
                    w->color = RED;                                                // CASE 3
                    right_rotate(tree, w);                                         // CASE 3
                    w = x->parent->right_child;                                    // CASE 3
                }

                w->color = x->parent->color;                                       // CASE 4
                x->parent->color = BLACK;                                          // CASE 4
                w->right_child->color = BLACK;                                     // CASE 4
                left_rotate(tree, x->parent);                                      // CASE 4
                x = tree->root_node;                                               // CASE 4
            }
        } else {
            struct rb_node* w = x->parent->left_child;

            if (w->color == RED) {
                w->color = BLACK;                                                  // CASE 1
                x->parent->color = RED;                                            // CASE 1
                right_rotate(tree, x->parent);                                     // CASE 1
                w = x->parent->left_child;                                         // CASE 1
            }

            if (w->right_child->color == BLACK && w->left_child->color == BLACK) {
                w->color = RED;                                                    // CASE 2
                x = x->parent;                                                     // CASE 2
            } else {
                if (w->left_child->color == BLACK) {
                    w->right_child->color = BLACK;                                 // CASE 3
                    w->color = RED;                                                // CASE 3
                    left_rotate(tree, w);                                          // CASE 3
                    w = x->parent->left_child;                                     // CASE 3
                }

                w->color = x->parent->color;                                       // CASE 4
                x->parent->color = BLACK;                                          // CASE 4
                w->left_child->color = BLACK;                                      // CASE 4
                right_rotate(tree, x->parent);                                     // CASE 4
                x = tree->root_node;                                               // CASE 4
            }
        }
    }
}

static void
__delete(struct rb_tree* tree, struct rb_node* z) {
    struct rb_node* x = NIL_NODE;
    struct rb_node* y = z;
    int y_original_color = y->color;

    tree->size--;

    if (z->left_child == NIL_NODE) {
        x = z->right_child;
        transplant(tree, z, z->right_child);
    } else if (z->right_child == NIL_NODE) {
        x = z->left_child;
        transplant(tree, z, z->left_child);
    } else {
        y = minimum(z->right_child);
        y_original_color = y->color;
        x = y->right_child;

        if (y->parent == z) {
            if (x == NIL_NODE) {
                x->parent = y; // This line is very important
            } else {
                assert(x->parent == y);
            }
        } else {
            transplant(tree, y, y->right_child);
            y->right_child = z->right_child;
            y->right_child->parent = y;
        }

        transplant(tree, z, y);
        y->left_child = z->left_child;
        y->left_child->parent = y;
        y->color = z->color;
    }

    del_node(z);

    if (y_original_color == BLACK) {
        delete_fixup(tree, x);
    }
}

static void
delete(struct rb_tree* tree, int delete_key) {
    struct rb_node* node = __search(tree, tree->root_node, delete_key);
    if (node != NIL_NODE) {
        __delete(tree, node);
    }
}

int main() {
    global_init();

    struct rb_tree* tree = new_rb_tree();

    int m = 10000;
    int i = 1;
    for (i = 1; i < m; ++i) {
        insert(tree, i, i * 3);
    }

    for (i = 1; i < m; ++i) {
        assert(search(tree, i) == (i * 3));
    }

    struct rb_node* node = minimum(tree->root_node);

    while (node != NIL_NODE) {
        printf("%d %d\n", node->key, node->val);
        node = successor(node);
    }

    node = maximum(tree->root_node);

    while (node != NIL_NODE) {
        printf("%d %d\n", node->key, node->val);
        node = predecessor(node);
    }

    for (i = 1; i < m; ++i) {
        delete(tree, i);
    }

    for (i = 1; i < m; ++i) {
        assert(search(tree, i) == 0);
    }

    del_rb_tree(tree);

    return 0;
}
