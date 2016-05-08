#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <time.h>
/*
 * Quick sort with recursion
 */
void check(int arr[], int left, int right) {
    int i;
    for (i = left; i < right; ++i) {
        assert(arr[i] <= arr[i+1]);
    }
}

void
swap(int arr[], int x, int y) {
    int tmp = arr[x];
    arr[x] = arr[y];
    arr[y] = tmp;
}

/* Lomuto partition scheme
 * left part is [left, mid-1]
 * right part is [mid+1, right]
 * */
int
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

void
lomuto_qsort(int arr[], int left, int right) {
    if (left < right) {
        int mid = lomuto_partition(arr, left, right);
        lomuto_qsort(arr, left, mid-1);
        lomuto_qsort(arr, mid+1, right);
    }
}

/* Hoare partition scheme
 * left part is [left, mid]
 * right part is [mid+1, right]
 * */
int
hoare_partition(int arr[], int left, int right) {
    int x = arr[left];
    int i = left - 1;
    int j = right + 1;

    while (1) {
        do {
            --j;
        } while (arr[j] > x);

        do {
            ++i;
        } while (arr[i] < x);

        if (i < j) {
            swap(arr, i, j);
        }
        else {
            return j;
        }
    }
}

void
hoare_qsort(int arr[], int left, int right) {
    if (left < right) {
        int mid = hoare_partition(arr, left, right);
        hoare_qsort(arr, left, mid);
        hoare_qsort(arr, mid+1, right);
    }
}

int
rand_num(int left, int right) {
    assert(left <= right);
    return left + rand() % (right - left + 1);
}

/* Random partition scheme
 * */
int
randomized_partition(int arr[], int left, int right) {
    int r = rand_num(left, right);
    swap(arr, r, right);
    return lomuto_partition(arr, left, right);
}

void
randomized_sort(int arr[], int left, int right) {
    if (left < right) {
        int mid = randomized_partition(arr, left, right);
        randomized_sort(arr, left, mid-1);
        randomized_sort(arr, mid+1, right);
    }
}

/* Quick sort with stack */

int main() {
    srand(time(NULL));

    int table[] = {
        13, 19, 9, 5, 12, 8, 7, 4, 11, 2, 6, 21,
    };

    int left = 0;
    int right = sizeof(table) / sizeof(int) - 1;

    lomuto_qsort(table, left, right);
    hoare_qsort(table, left, right);
    randomized_sort(table, left, right);

    check(table, left, right);

    return 0;
}
