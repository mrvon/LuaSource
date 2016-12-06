#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "uthash.h"

struct item {
    int id;             // key
    char name[10];
    UT_hash_handle hh;  // makes this structure hashable
};

void set(struct item **hash, int id, char* name) {
    struct item *s;

    // id already in the hash?
    HASH_FIND_INT(*hash, &id, s);
    if (s == NULL) {
        s = malloc(sizeof(struct item));
        s->id = id;
        HASH_ADD_INT(*hash, id, s); // id: name of key field
    }
    strcpy(s->name, name);
}

struct item* get(struct item **hash, int id) {
    struct item *s;
    HASH_FIND_INT(*hash, &id, s); // s: output pointer
    return s;
}

void del(struct item **hash, struct item* user) {
    HASH_DEL(*hash, user); // user: pointer to deletee
    free(user);
}

void delall(struct item **hash) {
    struct item* current_user;
    struct item* tmp;

    HASH_ITER(hh, *hash, current_user, tmp) {
        HASH_DEL(*hash, current_user); // delete it (hash advances to next)
        free(current_user); // free it
    }
}

void print(struct item **hash) {
    struct item* s;

    for (s = *hash; s != NULL; s = (struct item*)(s->hh.next)) {
        printf("user id %d: name %s\n", s->id, s->name);
    }
}

int name_sort(struct item* a, struct item* b) {
    return strcmp(a->name, b->name);
}

int id_sort(struct item* a, struct item* b) {
    return (a->id - b->id);
}

void sort_by_name(struct item **hash) {
    HASH_SORT(*hash, name_sort);
}

void sort_by_id(struct item **hash) {
    HASH_SORT(*hash, id_sort);
}

int main() {
    struct item** hash  = malloc(sizeof(struct item*));

    int id = 0;

    set(hash, id++, "dennis");
    set(hash, id++, "tom");
    set(hash, id++, "jerry");
    set(hash, id++, "ada");

    struct item* d = get(hash, 0);
    if (d) {
        printf("get %d %s\n", d->id, d->name);
    } else {
        printf("not found!\n");
    }

    del(hash, d);

    d = get(hash, 0);
    if (d) {
        printf("get %d %s\n", d->id, d->name);
    } else {
        printf("%d not found!\n", 0);
    }

    sort_by_name(hash);
    print(hash);

    sort_by_id(hash);
    print(hash);

    delall(hash);  // free any structures
    return 0;
}
