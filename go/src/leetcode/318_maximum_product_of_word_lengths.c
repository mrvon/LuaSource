#include <stdio.h>
#include <string.h>

int maxProduct(char** words, int wordsSize) {
    int i;
    int j;
    int m = 0;

    for (i = 0; i < wordsSize; i++) {
        for (j = i+1; j < wordsSize; j++) {
            int l = strlen(words[i]) * strlen(words[j]);
            if (l > m) {
                char unique[26] = {0};
                char* s1 = words[i];
                char* s2 = words[j];
                char c;
                int is_unique = 1;
                while (c = *s1++) {
                    unique[c-'a'] = 1;
                }
                while (c = *s2++) {
                    if (unique[c-'a']) {
                        is_unique = 0;
                        break;
                    }
                }
                if (is_unique) {
                    m = l;
                }
            }
        }
    }

    return m;
}

int main() {
    char* words[] =  {
        "hello",
        "world",
        "max",
        "product",
    };

    printf("%d\n", maxProduct(words,sizeof(words)/sizeof(char*)));
}
