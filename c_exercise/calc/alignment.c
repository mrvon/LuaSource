#include <stdio.h>

typedef struct Foo* PFoo;
typedef struct Foo {
    char c;
    short s;
    int i;
} Foo;

Foo* g = NULL;

Foo array[10];


int main(int argc, char const* argv[])
{
    printf("%lu\n", sizeof(Foo));
    printf("%lu\n", sizeof(g));
    printf("%lu\n", sizeof(*g));
    printf("%lu\n", sizeof(array));

    return 0;
}
