#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <assert.h>

struct Heap {
    int* inner_array;
    int size;
    int curr;
};

void __new_inner_array(struct Heap* h, int size) {
    h->size = size;
    h->curr = 0;
    h->inner_array = malloc(sizeof(int) * size);
    assert(h->inner_array);
}

void __del_inner_array(struct Heap* h) {
    free(h->inner_array);
}

void __append_inner_array(struct Heap* h, int val) {
    if (h->curr >= h->size) {
        h->size *= 2;
        h->inner_array = realloc(h->inner_array, h->size);
        assert(h->inner_array);
    }
    h->inner_array[h->curr++] = val;
}

int __pop_back_inner_array(struct Heap* h) {
    assert(h->curr > 0);
    h->curr--;
    return h->inner_array[h->curr];
}

struct Heap* new_heap() {
    struct Heap* h = malloc(sizeof(struct Heap));
    assert(h);
    __new_inner_array(h, 100);
    return h;
}

void del_heap(struct Heap* h) {
    __del_inner_array(h);
    free(h);
}

int len(struct Heap* h) {
    return h->curr;
}

bool less(struct Heap* h, int i, int j) {
    return h->inner_array[i] < h->inner_array[j];
}

void swap(struct Heap* h, int i, int j) {
    int tmp = h->inner_array[i];
    h->inner_array[i] = h->inner_array[j];
    h->inner_array[j] = tmp;
}

void __up(struct Heap* h, int j) {
    while (true) {
        int i = (j - 1) / 2; // parent
        if (i == j || !less(h, j, i)) {
            break;
        }
        swap(h, i, j);
        j = i;
    }
}

void __down(struct Heap* h, int i, int n) {
    while (true) {
        int j1 = 2*i + 1;
        if (j1 >= n || j1 < 0) { // j1 < 0 after int overflow
            break;
        }
        int j = j1; // left child
        int j2 = j1 + 1;
        if (j2 < n && !less(h, j1, j2)) {
            j = j2; // = 2*i + 2 // right child
        }
        if (!less(h, j, i)) {
            break;
        }
        swap(h, i, j);
        i = j;
    }
}

void push(struct Heap* h, int val) {
    __append_inner_array(h, val);
    __up(h, len(h)-1);
}

int pop(struct Heap* h) {
    int n = len(h) - 1;
    swap(h, 0, n);
    __down(h, 0, n);
    return __pop_back_inner_array(h);
}

int main() {
    struct Heap* h = new_heap();

    push(h, 1000);
    push(h, 1001);
    push(h, 1002);

    printf("%d\n", pop(h));
    printf("%d\n", pop(h));
    printf("%d\n", pop(h));

    del_heap(h);
}
