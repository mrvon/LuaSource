#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef struct {
    int* base;
    int* buff;
    int size;
} Solution;

int aux_rand(int max) {
    /* [0, max-1] */
    return (rand() % max);
}

void aux_swap(int* buff, int x, int y) {
    int temp = buff[x];
    buff[x] = buff[y];
    buff[y] = temp;
}

Solution* solutionCreate(int* nums, int size) {
    srand(time(NULL));

    int i;
    Solution* s = malloc(sizeof(*s));

    s->base = (int*)malloc(sizeof(int) * size);
    s->buff = (int*)malloc(sizeof(int) * size);
    s->size = size;

    for (i = 0; i < size; i++) {
        s->base[i] = nums[i];
        s->buff[i] = nums[i];
    }

    return s;
}

/** Resets the array to its original configuration and return it. */
int* solutionReset(Solution* obj, int *returnSize) {
    int i;
    for (i = 0; i < obj->size; i++) {
        obj->buff[i] = obj->base[i];
    }
    *returnSize = obj->size;
    return obj->buff;
}

/** Returns a random shuffling of the array. */
int* solutionShuffle(Solution* obj, int *returnSize) {
    int i = obj->size - 1;
    while (i > 0) {
        int r = aux_rand(i);
        aux_swap(obj->buff, r, i);
        i--;
    }
    *returnSize = obj->size;
    return obj->buff;
}

void solutionFree(Solution* obj) {
    free(obj->base);
    free(obj->buff);
    free(obj);
}

void debug(int* arr, int size) {
    for (int i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int main() {
    int nums[] = {
        0,1,2,3
    };
    int size = sizeof(nums) / sizeof(int);
    int s;

    Solution* obj = solutionCreate(nums, size);
    int* param_1 = solutionShuffle(obj, &s);
    debug(param_1, s);
    int* param_2 = solutionReset(obj, &s);
    debug(param_2, s);
    int* param_3 = solutionShuffle(obj, &s);
    debug(param_3, s);
    solutionFree(obj);

    return 0;
}
