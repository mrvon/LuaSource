#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

struct stack_node {
    int left;
    int right;
};

struct stack {
    struct stack_node* list;
    int size;
    int index;
};

static struct stack* stack_new() {
    struct stack* s = (struct stack*)malloc(sizeof(*s));
    assert(s);

    s->index = 0;
    s->size = 1000;
    s->list = (struct stack_node*)malloc(sizeof(struct stack_node) * s->size);
    assert(s->list);

    return s;
}

static void stack_del(struct stack* s) {
    free(s);
}

static void stack_push(struct stack* s, int left, int right) {
    if (s->index >= s->size) {
        assert(s->size*2 > s->size);

        s->size *= 2;
        s->list = realloc(s->list, sizeof(struct stack_node) * s->size);
        assert(s->list);
    }

    s->list[s->index].left = left;
    s->list[s->index].right = right;

    s->index++;
}

static void stack_pop(struct stack* s, int* left, int* right) {
    assert(s->index > 0);

    s->index--;

    (*left) = s->list[s->index].left;
    (*right) = s->list[s->index].right;
}

static int stack_empty(struct stack* s) {
    return s->index == 0;
}

static void
check(int arr[], int left, int right) {
    int i;
    for (i = left; i < right; ++i) {
        assert(arr[i] <= arr[i+1]);
    }
}

static void
swap(int arr[], int x, int y) {
    int tmp = arr[x];
    arr[x] = arr[y];
    arr[y] = tmp;
}

/* Lomuto partition scheme
 * left part is [left, mid-1]
 * right part is [mid+1, right]
 * */
static int
lomuto_partition(int arr[], int left, int right) {
    int x = arr[right];
    int i = left - 1;
    int j = left;
    for (; j <= right - 1; ++j) {
        if (arr[j] <= x) {
            ++i;
            swap(arr, i, j);
        }
    }
    swap(arr, i+1, right);
    return i + 1;
}

static void
quick_sort_with_stack(int arr[], int left, int right) {
    struct stack* s = stack_new();

    stack_push(s, left, right);

    while (! stack_empty(s)) {
        int l;
        int r;

        stack_pop(s, &l, &r);

        if (l < r) {
            int m = lomuto_partition(arr, l, r);

            stack_push(s, l, m-1);
            stack_push(s, m+1, r);
        }
    }

    stack_del(s);
}

int
main() {
    int table[] = {
        13, 19, 9, 5, 12, 8, 7, 4, 11, 2, 6, 21,
    };

    int left = 0;
    int right = sizeof(table) / sizeof(int) - 1;

    quick_sort_with_stack(table, left, right);

    check(table, left, right);

    return 0;
}
