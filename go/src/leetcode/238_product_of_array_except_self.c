#include <stdio.h>
#include <stdlib.h>

/**
 * Return an array of size *returnSize.
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* productExceptSelf(int* nums, int numsSize, int* returnSize) {
    int* ans = malloc(sizeof(int) * numsSize);
    int k;

    for (k = 0; k < numsSize; k++) {
        ans[k] = 1;
    }

    *returnSize = numsSize;

    // i is the position of left product pointer, lp is left product
    // j is the position of right product pointer, rp is right product
    int i = 0;
    int j = numsSize - 1;
    int lp = 1;
    int rp = 1;

    for (; i < numsSize;) {
        // update ans elements
        ans[i] *= lp;
        ans[j] *= rp;

        lp *= nums[i++];
        rp *= nums[j--];
    }

    /*
     * for index i 
    ans[0] *= 1
    ans[1] *= nums[0]
    ans[2] *= (nums[0] * nums[1])
    ...
    ans[n-3] *= (nums[0] * nums[1] * ... * nums[n-4])
    ans[n-2] *= (nums[0] * nums[1] * ... * nums[n-3])
    ans[n-1] *= (nums[0] * nums[1] * ... * nums[n-2])

     * for index j
    ans[n-1] *= 1
    ans[n-2] *= nums[n-1]
    ans[n-3] *= (nums[n-1] * nums[n-2])
    ...
    ans[2] *= (nums[n-1] * nums[n-2] ... * nums[3])
    ans[1] *= (nums[n-1] * nums[n-2] ... * nums[2])
    ans[0] *= (nums[n-1] * nums[n-2] ... * nums[1])
    */

    return ans;
}

int main(){
    int arr[] = {1, 2, 3, 4};
    int size = sizeof(arr) / sizeof(int);
    int ret;
    int* res;
    int i;

    res = productExceptSelf(arr, size, &ret);

    for (i = 0; i < ret; i++) {
        printf("%d ", res[i]);
    }
    printf("\n");
}
