#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <assert.h>

struct Item {
    int val;        // The value of the item.
    int priority;   // The priority of the item in the queue.
    // The index is needed by update and is maintained by the heap.
    int index;      // The index of the item in the heap.
};

struct Item* new_item(int val, int priority) {
    struct Item* i = malloc(sizeof(struct Item));
    assert(i);
    i->val = val;
    i->priority = priority;
    return i;
}

void del_item(struct Item* item) {
    assert(item);
    free(item);
}

struct Heap {
    struct Item** inner_array;
    int size;
    int curr;
};

void __new_inner_array(struct Heap* h, int size) {
    h->size = size;
    h->curr = 0;
    h->inner_array = malloc(sizeof(struct Item*) * size);
    assert(h->inner_array);
}

void __del_inner_array(struct Heap* h) {
    assert(h);
    int i = 0;
    for (i = 0; i < h->curr; i++) {
        del_item(h->inner_array[i]);
    }
    free(h->inner_array);
}

void __append_inner_array(struct Heap* h, struct Item* item) {
    if (h->curr >= h->size) {
        h->size *= 2;
        h->inner_array = realloc(h->inner_array, h->size);
        assert(h->inner_array);
    }
    item->index = h->curr;
    h->inner_array[h->curr++] = item;
}

struct Item* __pop_back_inner_array(struct Heap* h) {
    assert(h->curr > 0);
    h->curr--;
    struct Item* item = h->inner_array[h->curr];
    item->index = -1; // for safety
    return item;
}

struct Heap* new_heap() {
    struct Heap* h = malloc(sizeof(struct Heap));
    assert(h);
    __new_inner_array(h, 100);
    return h;
}

void del_heap(struct Heap* h) {
    __del_inner_array(h);
    assert(h);
    free(h);
}

int len(struct Heap* h) {
    return h->curr;
}

bool less(struct Heap* h, int i, int j) {
    return h->inner_array[i]->priority < h->inner_array[j]->priority;
}

void swap(struct Heap* h, int i, int j) {
    struct Item* tmp = h->inner_array[i];
    h->inner_array[i] = h->inner_array[j];
    h->inner_array[j] = tmp;
    h->inner_array[i]->index = i;
    h->inner_array[j]->index = j;
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

struct Item* pop(struct Heap* h);

struct Item* __remove(struct Heap* h, int i) {
    int n = len(h) - 1;
    if (n != i) {
        swap(h, i, n);
        __down(h, i, n);
        __up(h, i);
    }
    return pop(h);
}

// Fix re-establishes the heap ordering after the element at index i has changed its value.
// Changing the value of the element at index i and then calling Fix is equivalent to,
// but less expensive than, calling Remove(h, i) followed by a Push of the new value.
// The complexity is O(log(n)) where n = h.Len().
void __fix(struct Heap* h, int i) {
    __down(h, i, len(h));
    __up(h, i);
}

void push(struct Heap* h, struct Item* item) {
    __append_inner_array(h, item);
    __up(h, len(h)-1);
}

struct Item* pop(struct Heap* h) {
    int n = len(h) - 1;
    swap(h, 0, n);
    __down(h, 0, n);
    return __pop_back_inner_array(h);
}

void update(struct Heap* h, struct Item* item) {
    __fix(h, item->index);
}

int main() {
    struct Heap* h = new_heap();

    push(h, new_item(3, 103));
    push(h, new_item(1, 101));
    push(h, new_item(2, 102));

    struct Item* i = pop(h);
    printf("Val:%d Priority:%d\n", i->val, i->priority);

    i = pop(h);
    printf("Val:%d Priority:%d\n", i->val, i->priority);

    i = pop(h);
    printf("Val:%d Priority:%d\n", i->val, i->priority);

    push(h, new_item(1, 999));
    push(h, new_item(2, 101));
    push(h, new_item(3, 888));
    push(h, new_item(4, 777));

    i = new_item(5, 666);
    push(h, i);

    i->priority = 100;
    update(h, i);

    i = pop(h);
    printf("Val:%d Priority:%d\n", i->val, i->priority);

    del_heap(h);
}
