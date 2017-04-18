#include <stdio.h>
#include <assert.h>

int main() {
    char c = -1;

    // in mac, type char is signed.
    assert(c < 0);

    printf("%d\n", c);

    // if you want to store c in a unsigned int, keep its original bit
    
    // you should convert it to unsigned char first
    unsigned int ui = (unsigned char)c;

    printf("%u\n", ui);

    // otherwise, the result is different.
    unsigned int i = c;

    printf("%u\n", i);
}
