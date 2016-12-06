#include <stdio.h>

// brute force - O(2^n)
int bf_findDuplicate(int* nums, int numsSize) {
    int i;
    int j;
    for (i = 0; i < numsSize; i++) {
        for (j = i+1; j < numsSize; j++) {
            if (nums[i] == nums[j]) {
                return nums[i];
            }
        }
    }
    return -1;
}

int findDuplicate(int* nums, int numsSize) {
    if (numsSize == 0) {
        return 0;
    }

    int low = 1;
    int high = numsSize - 1;

    while (low < high) {
        int mid = low + (high - low) / 2;
        int count = 0;
        int i;

        // NOTICE! we must always scan the whole array
        for (i = 0; i < numsSize; i++) {
            // In the whole array, how many element less or equal than mid
            if ((nums[i]) <= mid) {
                count++;
            }
        }
        printf("DEBUG: %d\n", count);
        // if count > mid, it means that it must be have element duplicate in
        // the range(1, mid)
        if (count > mid) {
            high = mid;
        } else {
            // Otherwise, must be in the range (mid+1, numsSize-1)
            low = mid + 1;
        }
    }

    return low;
}

int main() {
    int arr[] = {
        1,2,3,3,4
    };
    printf("%d\n", findDuplicate(arr, sizeof(arr)/sizeof(int)));
}
