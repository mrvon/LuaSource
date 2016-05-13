#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

/* simulate correct_stack in lua source code */

int main(int argc, char const* argv[])
{
    int i;
    int size = 10;
    int new_size = 1000000;
    int* arr = (int*)malloc(sizeof(int) * size);
    int* old_arr;
    assert(arr);

    for (i = 0; i < size; ++i) {
        arr[i] = i * 999;
    }

    int *p = arr + 1;
    printf("*p = %d\n", *p);

    printf("BEFORE: \n");
    printf("arr= %p\n", arr);
    printf("p= %p\n", p);

    old_arr = arr;

    arr = realloc(arr, new_size);
    assert(arr);

    p = p - old_arr + arr;

    printf("AFTER: \n");
    printf("arr= %p\n", arr);
    printf("p= %p\n", p);

    printf("*p = %d\n", *p);

    return 0;
}
