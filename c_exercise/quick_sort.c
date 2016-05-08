#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <time.h>
/*
 * Quick sort with recursion
 */
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
static int
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

static void
hoare_qsort(int arr[], int left, int right) {
    if (left < right) {
        int mid = hoare_partition(arr, left, right);
        hoare_qsort(arr, left, mid);
        hoare_qsort(arr, mid+1, right);
    }
}

/* median of 3 partition scheme
 * */
static int
median_of_three_partition(int arr[], int left, int right) {
    int mid = left + (right - left) / 2;

    if (arr[left] >= arr[mid] && arr[left] <= arr[right]) {
        swap(arr, left, right);
    } else if (arr[mid] >= arr[left] && arr[mid] <= arr[right]) {
        swap(arr, mid, right);
    }

    return lomuto_partition(arr, left, right);
}

static void
median_of_three_qsort(int arr[], int left, int right) {
    if (left < right) {
        int mid = median_of_three_partition(arr, left, right);
        median_of_three_qsort(arr, left, mid-1);
        median_of_three_qsort(arr, mid+1, right);
    }
}


static int
rand_num(int left, int right) {
    assert(left <= right);
    return left + rand() % (right - left + 1);
}

/* Random partition scheme
 * */
static int
randomized_partition(int arr[], int left, int right) {
    int r = rand_num(left, right);
    swap(arr, r, right);
    return lomuto_partition(arr, left, right);
}

static void
randomized_sort(int arr[], int left, int right) {
    if (left < right) {
        int mid = randomized_partition(arr, left, right);
        randomized_sort(arr, left, mid-1);
        randomized_sort(arr, mid+1, right);
    }
}

int*
gen_test_arr(int size) {
    int* arr = (int*)malloc(size * sizeof(int));
    assert(arr);

    int i;
    for (i = 0; i < size; ++i) {
        arr[i] = rand_num(0, size);
    }

    return arr;
}

void
del_test_arr(int* arr) {
    assert(arr);
    free((void*)arr);
}

int
main() {
    srand(time(NULL));

    int size = 100000;

    int left = 0;
    int right = size - 1;

    int* arr = gen_test_arr(size);

    /* that's quick when element in array is random shuffle */
    lomuto_qsort(arr, left, right);
    printf("1 lomuto_qsort is done\n");

    /* that's very slow when all element in array is sorted */
    lomuto_qsort(arr, left, right);
    printf("2 lomuto_qsort is done\n");

    /* that's very slow when all element in array is sorted */
    hoare_qsort(arr, left, right);
    printf("3 hoare_qsort is done\n");

    /* performance is always pertty good */
    randomized_sort(arr, left, right);
    printf("4 randomized_sort is done\n");

    /* performance is always pertty good */
    median_of_three_qsort(arr, left, right);
    printf("5 median_of_three_qsort is done\n");

    check(arr, left, right);

    del_test_arr(arr);

    return 0;
}
