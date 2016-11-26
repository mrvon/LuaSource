#include <stdlib.h>
#include <stdio.h>

char* convertToTitle(int n) {
    int size = 100;
    char* result = malloc(size);
    int index = 0;

    while (n > 0) {
        int r = (n-1) % 26;
        char c = r + 'A';
        n = (n-1) / 26;

        if (index >= size) {
            size *= 2;
            result = realloc(result, size);
        }
        result[index++] = c;
    }

    result[index] = '\0';

    int i = 0;
    int j = index-1;

    while (i < j) {
        char tmp = result[i];
        result[i] = result[j];
        result[j] = tmp;
        i++;
        j--;
    }

    return result;
}

int main() {
    printf("%s\n", convertToTitle(1));
    printf("%s\n", convertToTitle(26));
    printf("%s\n", convertToTitle(27));
    printf("%s\n", convertToTitle(28));
    printf("%s\n", convertToTitle(703));
}
