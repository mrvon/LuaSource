#include <stdio.h>

int binary_search(int arr[], int n, int find)
{
    int low = 0;
    int high = n - 1;
    int mid;

    while (low <= high) {
        mid = (low + high) / 2;
        if (find < arr[mid]) {
            high = mid - 1;
        }
        else if (find > arr[mid]) {
            low = mid + 1;
        }
        else {
            return mid;
        }
    }

    return -1;
}

int main() {
    int arr[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 25, 30, 100};
    printf("%d\n", binary_search(arr, sizeof(arr)/sizeof(int), 30));
    printf("%d\n", binary_search(arr, sizeof(arr)/sizeof(int), 2));
    printf("%d\n", binary_search(arr, sizeof(arr)/sizeof(int), 1));
    printf("%d\n", binary_search(arr, sizeof(arr)/sizeof(int), 1000));
    return 0;
}
