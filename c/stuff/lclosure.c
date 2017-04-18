#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

// Show A tricy about THIS

typedef struct Num {
    int i;
} Num;

typedef struct LClosure {
    int foo;
    int goo;
	Num *num_array[1];  // list of Num (THIS)
} LClosure;

#define sizeLclosure(n)	(sizeof(LClosure) + \
        sizeof(Num*) * ((n)-1))

#define dprint(exp) printf("%s = %d\n", #exp, exp);

int main(int argc, char const* argv[])
{
    int i;
    int n = 10;
    LClosure* c = (LClosure*) malloc(sizeLclosure(n));
    assert(c);

    c->foo = 0;
    c->goo = 0;

    for (i = 0; i < n; ++i) {
        c->num_array[i] = (Num*) malloc(sizeof(Num));
        assert(c->num_array[i]);
        c->num_array[i]->i = i;
    }

    dprint(c->foo);
    dprint(c->goo);

    for (i = 0; i < n; ++i) {
        dprint(c->num_array[i]->i);
    }

    return 0;
}
