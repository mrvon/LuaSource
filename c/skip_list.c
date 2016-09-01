/*

Search (list, searchKey)
    x := list->header

    -- loop invariant: x->key < searchKey

    for i := list->level downto 1 do
        while x->forward[i]->key < searchKey do
            x := x->forward[i]

    -- x->key < searchKey <= x->forward[1]->key

    x := x->forward[1]

    if x->key = searchKey then
        return x->value
    else
        return failure


Insert (list, searchKey, newValue)
    local update[1..MaxLevel]

    x := list->header

    for i := list->level downto 1 do
        while x->forward[i]->key < searchKey do
            x := x->forward[i]
        -- x->key < searchKey <= x->forward[i]->key
        update[i] := x

    x := x->forward[1]

    if x->key = searchKey then
        x->value := newValue
    else
        |v| := randonLevel()
        if |v| > list->level then
            for i := list->level + 1 to |v| do
                update[i] := list->header
            list->level = |v|
        x := makeNode(|v|, searchKey, value)
        for i := 1 to level do
            x->forward[i] := update[i]->forward[i]
            update[i]->forward[i] := x


Delete(list, searchKey)
    local update[1..MaxLevel]

    x := list->header

    for i := list->level downto 1 do
        while x->forward[i]->key < searchKey do
            x := x->forward[i]
        update[i] := x

    x := x->forward[1]

    if x->key = searchKey then
        for i := 1 to list->level do
            if update[i]->forward[i] != x then
                break
            update[i]->forward[i] := x->forward[i]

        free(x)

        while list->level > 1 and list->header->forward[list->level] = NIL do
            list->level := list->level - 1


randomLevel()
    |v| := 1

    -- random() that returns a random value in [0...1)

    while random() < p and |v| < MaxLevel do
        |v| := |v| + 1

    return |v|

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <time.h>

#define PROBABILITY     0.5
#define MAX_LEVEL       16

struct list_node {
    int key;
    int val;
    struct list_node* forward[1];
};

struct skip_list {
    int level;
    struct list_node* header;
};

static void
random_init() {
    srand(time(NULL));
}

static double
random_range() {
    // [0, 1)
    return (double)rand() / ((double)RAND_MAX + 1) ;
}

static int
random_level() {
    int level = 1;

    while ((random_range() < PROBABILITY) && (level < MAX_LEVEL)) {
        level++;
    }

    return level;
}

static struct list_node*
new_node(int level) {
    assert(level >= 1);

    size_t size = sizeof(struct list_node) + sizeof(struct list_node*) * (level - 1);
    struct list_node* node = (struct list_node*)malloc(size);

    assert(node);
    memset(node, 0, size);

    return node;
}

static struct skip_list*
new_list() {
    struct skip_list* list = (struct skip_list*)malloc(sizeof(*list));
    assert(list);

    list->level = 1;
    list->header = new_node(MAX_LEVEL);

    return list;
}

static void
del_list(struct skip_list* list) {
    assert(list);
    free((void*)list);
}

static int
search(struct skip_list* list, int search_key) {
    struct list_node* x = list->header;

    int i;
    for (i = list->level - 1; i >= 0; --i) {
        while (x->forward[i] && x->forward[i]->key < search_key) {
            x = x->forward[i];
        }
    }

    x = x->forward[0];

    if (x && x->key == search_key) {
        return x->val;
    } else {
        return 0;
    }
}

static void
insert(struct skip_list* list, int insert_key, int insert_val) {
    static struct list_node* update[MAX_LEVEL];
    struct list_node* x = list->header;
    int level;
    int i;

    memset(update, 0, sizeof(update));

    for (i = list->level - 1; i >= 0; --i) {
        while (x->forward[i] && x->forward[i]->key < insert_key) {
            x = x->forward[i];
        }
        update[i] = x;
    }

    x = x->forward[0];

    if (x && x->key == insert_key) {
        x->val = insert_val;
    } else {
        level = random_level();

        if (level > list->level) {
            for (i = list->level; i <= level - 1; ++i) {
                update[i] = list->header;
            }
            list->level = level;
        }

        x = new_node(level);
        x->key = insert_key;
        x->val = insert_val;

        for (i = 0; i <= level - 1; ++i) {
            x->forward[i] = update[i]->forward[i];
            update[i]->forward[i] = x;
        }
    }
}

static void
delete(struct skip_list* list, int delete_key) {
    static struct list_node* update[MAX_LEVEL];
    struct list_node* x = list->header;
    int i;

    memset(update, 0, sizeof(update));

    for (i = list->level - 1; i >= 0; --i) {
        while (x->forward[i] && x->forward[i]->key < delete_key) {
            x = x->forward[i];
        }
        update[i] = x;
    }

    x = x->forward[0];

    if (x && x->key == delete_key) {
        for (i = 0; i <= list->level - 1; ++i) {
            assert(update[i]);
            if (update[i]->forward[i] != x) {
                break;
            }
            update[i]->forward[i] = x->forward[i];
        }

        free(x);

        while (list->level > 1 && list->header->forward[list->level - 1] == NULL) {
            --list->level;
        }
    }
}

static void
print_val(int key, int val) {
    printf("%d %d\n", key, val);
}

static void
traverse(struct skip_list* list, void (*func)(int, int)) {
    struct list_node* x = list->header;

    x = x->forward[0];

    while (x) {
        func(x->key, x->val);
        x = x->forward[0];
    }
}

int 
main() {
    random_init();

    struct skip_list* list = new_list();

    int m = 10000;
    int i = 1;
    for (i = 1; i < m; ++i) {
        insert(list, i, i * 3);
    }

    for (i = 1; i < m; ++i) {
        assert(search(list, i) == (i * 3));
    }

    /* traverse(list, print_val); */

    for (i = 1; i < m; ++i) {
        delete(list, i);
    }

    for (i = 1; i < m; ++i) {
        assert(search(list, i) == 0);
    }

    del_list(list);

    printf("OK\n");

    return 0;
}

