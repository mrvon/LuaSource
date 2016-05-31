#include <iostream>
#include <stack>
#include <cassert>

using namespace std;

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
quick_sort_with_stack(int arr[], int left, int right) {
    stack<pair<int, int> > s;

    s.push(make_pair(left, right));

    while (! s.empty()) {
        pair<int, int> p = s.top();
        s.pop();

        int l = p.first;
        int r = p.second;

        if (l < r) {
            int m = lomuto_partition(arr, l, r);

            s.push(make_pair(l, m-1));
            s.push(make_pair(m+1, r));
        }
    }
}

int
main() {
    int table[] = {
        13, 19, 9, 5, 12, 8, 7, 4, 11, 2, 6, 21,
    };

    int left = 0;
    int right = sizeof(table) / sizeof(int) - 1;

    quick_sort_with_stack(table, left, right);

    check(table, left, right);

    return 0;
}
