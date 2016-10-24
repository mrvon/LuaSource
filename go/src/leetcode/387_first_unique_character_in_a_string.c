#include <stdio.h>

int firstUniqChar(char* s) {
    int counter[26] = {0};
    char *p;
    char c;
    int i;

    p = s;
    while ((c = *p++)) {
        counter[c-'a']++;
    }

    i = 0;
    p = s;
    while ((c = *p++)) {
        if (counter[c-'a'] == 1) {
            return i;
        }
        i++;
    }

    return -1;
}

int main() {
    printf("%d\n", firstuniqchar("leetcode"));
    printf("%d\n", firstuniqchar("loveleetcode"));
}
