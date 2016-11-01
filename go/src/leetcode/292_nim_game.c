#include <stdio.h>
#include <stdbool.h>

/* Time Limit Exceeded

bool canWinNim(int n) {
    if (n == 0) {
        return true;
    } else if (n == 1) {
        return true;
    } else if (n == 2) {
        return true;
    } else if (n == 3) {
        return true;
    } else {
        return (
            (canWinNim(1) && !canWinNim(n-1)) ||
            (canWinNim(2) && !canWinNim(n-2)) ||
            (canWinNim(3) && !canWinNim(n-3))
            );
    }
}

*/

bool canWinNim(int n) {
    if (n % 4 != 0) {
        return true;
    } else {
        return false;
    }
}

int main() {
    int i;

    for (i = 1; i < 30; i++) {
        printf("%d\n", canWinNim(i));
    }
}
