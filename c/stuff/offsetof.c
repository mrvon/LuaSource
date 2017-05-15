#include <stdio.h>
#include <stddef.h>

struct Foo {
	int n;
	char c;
	double f;
	int n2;
};

int main()
{
    printf("INT: %lu\n", offsetof(struct Foo, n));
    printf("CHAR: %lu\n", offsetof(struct Foo, c));
    printf("DOUBLE: %lu\n", offsetof(struct Foo, f));
    printf("INT: %lu\n", offsetof(struct Foo, n2));

    return 0;
}

