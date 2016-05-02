/*
 * malloc   // alloc without zero initialization, you maybe should call memset by yourself
 * calloc   // alloc with zero initialization
 * realloc  // resize memory blocks
 * free     // release memory blocks
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

static void *
lua_alloc (void *ud, void *ptr, size_t osize, size_t nsize) {
    (void)ud; (void)osize;  /* not used */
    if (nsize == 0) {
        free(ptr);
        return NULL;
    }
    else
        return realloc(ptr, nsize);
}

int main() {
    const char* str = "hello";
    const char* str_2 = "hello world, the c programming language";

    size_t len = strlen(str);
    size_t len_2 = strlen(str_2);

    char* block = (char*) malloc(len + 1);
    memcpy(block, str, len + 1);

    printf("%s\n", block);

    block = (char*) realloc((void*)block, len_2 + 1);
    printf("%s\n", block);

    memcpy(block, str_2, len_2 + 1);
    printf("%s\n", block);

    free((void*)block);
    block = NULL;

    int i;
    size_t size = 100000;
    char* zero_block = (char*) calloc(sizeof(char), size);

    for (i = 0; i < size ; ++i) {
        assert(*zero_block == 0);
    }

    free((void*) zero_block);
    zero_block = NULL;

    /* ---------------------------------------------------------------------- */
    // alloc block
    block = lua_alloc(NULL, NULL, 0, len_2 + 1);
    memcpy(block, str_2, len_2 + 1);

    printf("%s\n", block);

    // resize(shrink block)
    block = lua_alloc(NULL, block, len_2 + 1, len + 1);
    memcpy(block, str, len + 1);

    printf("%s\n", block);

    // free block
    lua_alloc(NULL, block, len + 1, 0);

    return 0;
}
