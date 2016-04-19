#include <stdio.h>
#include <assert.h>

/* x64 gcc */
#define DOUBLE_LEN  8
#define FLOAT_LEN   4
#define INT_LEN     4
#define LONG_LEN    8
#define SHORT_LEN   2
#define CHAR_LEN    1

struct A {
    int a;
};

struct B {
    int a;
    char b;
};

struct C {
    char a;
    int b;
};

struct D {
    char a;
};

struct E {
    char a;
    char b;
};

struct F {
    char a;
    char b;
} __attribute__((packed, aligned(4)));

struct G {
    int     a;
    short   b;
    char    c;
    double  d;
    float   e;
};

struct H {
    double  a;
    int     b;
    short   c;
    char    d;
    float   e;
};

struct I {
    char    a;
    short   b;
    int     c;
    float   d;
    double  e;
};

struct L {
    int     a;
    short   b;
    char    c;
    double  d;
    float   e;
} __attribute__((packed, aligned(1)));

int main(int argc, char const* argv[])
{
    assert(sizeof(double) == DOUBLE_LEN);
    assert(sizeof(float)  == FLOAT_LEN);
    assert(sizeof(int)    == INT_LEN);
    assert(sizeof(long)   == LONG_LEN);
    assert(sizeof(short)  == SHORT_LEN);
    assert(sizeof(char)   == CHAR_LEN);

    // |4|
    assert(__alignof__(struct A) == INT_LEN);
    assert(sizeof(struct A) == 4);

    // |4|1xxx|
    assert(__alignof__(struct B) == INT_LEN);
    assert(sizeof(struct B) == 8);

    // |1xxx|4|
    assert(__alignof__(struct C) == INT_LEN);
    assert(sizeof(struct C) == 8);

    // |1|
    assert(__alignof__(struct D) == CHAR_LEN);
    assert(sizeof(struct D) == 1);

    // |1|1|
    assert(__alignof__(struct E) == CHAR_LEN);
    assert(sizeof(struct E) == 2);

    // |1|1xx|
    assert(__alignof__(struct F) == 4);
    assert(sizeof(struct F) == 4);

    // |4|2xx|1xxx|8|4|
    assert(__alignof__(struct G) == DOUBLE_LEN);
    assert(sizeof(struct G) == 24);

    // |8|4|2|1|x|4xxxx|
    assert(__alignof__(struct H) == DOUBLE_LEN);
    assert(sizeof(struct H) == 24);

    // |1x|2|4|4xxxx|8|
    assert(__alignof__(struct I) == DOUBLE_LEN);
    assert(sizeof(struct I) == 24);

    // |4|2|1|8|4|
    assert(__alignof__(struct L) == 1);
    assert(sizeof(struct L) == 19);

    return 0;
}
