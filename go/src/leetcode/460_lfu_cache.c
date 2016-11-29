#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <assert.h>
#include "uthash.h"

//------------------------------------------------------------------------------
struct Item {
    int key;        // The key of the item.
    int val;        // The value of the item.
    int time;       // The access time of the item.
    int priority;   // The priority of the item in the queue.
    // The index is needed by update and is maintained by the heap.
    int index;      // The index of the item in the heap.
};

struct Item* new_item(int key, int val, int time, int priority) {
    struct Item* i = malloc(sizeof(struct Item));
    assert(i);
    i->key = key;
    i->val = val;
    i->time = time;
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
    if (h->inner_array[i]->priority < h->inner_array[j]->priority) {
        return true;
    } else if (h->inner_array[i]->priority == h->inner_array[j]->priority) {
        return h->inner_array[i]->time <= h->inner_array[j]->time;
    } else {
        return false;
    }
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
//------------------------------------------------------------------------------

struct HItem {
    int id; // key
    struct Item* val; // value
    UT_hash_handle hh;  // makes this structure hashable
};

void hash_add(struct HItem** hash, int id, struct Item* item) {
    struct HItem* s;

    // id already in the hash?
    HASH_FIND_INT(*hash, &id, s);
    if (s == NULL) {
        s = malloc(sizeof(struct HItem));
        s->id = id;
        s->val = item;
        HASH_ADD_INT(*hash, id, s); // id: name of key field
    }
}

struct HItem* hash_find(struct HItem** hash, int id) {
    struct HItem* s;
    HASH_FIND_INT(*hash, &id, s); // s: output pointer
    return s;
}

void hash_del(struct HItem** hash, struct HItem* item) {
    HASH_DEL(*hash, item); // pointer to deletee
    free(item);
}

void hash_delall(struct HItem** hash) {
    struct HItem* curr_item;
    struct HItem* tmp;

    HASH_ITER(hh, *hash, curr_item, tmp) {
        HASH_DEL(*hash, curr_item); // delete it
        free(curr_item); // free it
    }
}
//------------------------------------------------------------------------------

typedef struct {
    struct HItem** hash;
    struct Heap* heap;
    int capacity;
    int current;
    int timestamp;
} LFUCache;

LFUCache* lFUCacheCreate(int capacity) {
    LFUCache* obj = malloc(sizeof(LFUCache));
    obj->hash = malloc(sizeof(struct HItem*));
    *(obj->hash) = NULL;
    obj->heap = new_heap();
    obj->capacity = capacity;
    obj->current = 0;
    obj->timestamp = 0;
    return obj;
}

int lFUCacheGet(LFUCache* obj, int key) {
    struct HItem* hi = hash_find(obj->hash, key);
    if (hi == NULL) {
        return -1;
    }

    struct Item* i = hi->val;
    i->time = obj->timestamp++;
    i->priority++;
    update(obj->heap, i);

    return i->val;
}

void lFUCacheSet(LFUCache* obj, int key, int value) {
    if (obj->capacity <= 0) {
        return;
    }

    // try set
    struct HItem* hi = hash_find(obj->hash, key);
    if (hi != NULL) {
        struct Item* i = hi->val;
        i->time = obj->timestamp++;
        i->priority++;
        i->val = value;
        update(obj->heap, i);
        return;
    }

    // just insert
    if (obj->current >= obj->capacity) {
        struct Item* i = pop(obj->heap);
        // remove from hash
        struct HItem* hi = hash_find(obj->hash, i->key);
        hash_del(obj->hash, hi);
        del_item(i);
    } else {
        obj->current++;
    }
    struct Item* item = new_item(key, value, obj->timestamp++, 0);
    hash_add(obj->hash, key, item);
    push(obj->heap, item);
}

void lFUCacheFree(LFUCache* obj) {
    del_heap(obj->heap);
    free(obj);
}

void test_1() {
    const int capacity = 2;
    LFUCache* obj = lFUCacheCreate(capacity);

    lFUCacheSet(obj, 1, 1);
    lFUCacheSet(obj, 2, 2);
    assert(lFUCacheGet(obj, 1) == 1);  // returns 1
    lFUCacheSet(obj, 3, 3);            // evicts key 2
    assert(lFUCacheGet(obj, 2) == -1); // returns -1 (not found)
    assert(lFUCacheGet(obj, 3) == 3);  // returns 3.
    lFUCacheSet(obj, 4, 4);            // evicts key 1.
    assert(lFUCacheGet(obj, 1) == -1); // returns -1 (not found)
    assert(lFUCacheGet(obj, 3) == 3);  // returns 3
    assert(lFUCacheGet(obj, 4) == 4);  // returns 4
    lFUCacheSet(obj, 3, 1);
    assert(lFUCacheGet(obj, 3) == 1);  // returns 1 (overlap)
}

void test_2() {
    const int capacity = 2;
    LFUCache* obj = lFUCacheCreate(capacity);

    lFUCacheSet(obj, 2, 1);
    lFUCacheSet(obj, 1, 1);
    lFUCacheSet(obj, 2, 3);
    lFUCacheSet(obj, 4, 1);
    assert(lFUCacheGet(obj, 1) == -1);
    assert(lFUCacheGet(obj, 2) == 3);
}

void test_3() {
    const int capacity = 0;
    LFUCache* obj = lFUCacheCreate(capacity);

    lFUCacheSet(obj, 0, 0);
    assert(lFUCacheGet(obj, 0) == -1);
}

int main() {
    test_1();
    test_2();
    test_3();
}
