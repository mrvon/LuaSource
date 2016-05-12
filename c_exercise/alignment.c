/*
Data Alignment

    Many computer systems place restrictions on the allowable addresses for the
primitive data types, requiring that the address for some type of object must be a
multiple of some value K (typically 2, 4, or 8). Such alignment restrictions simplify
the design of the hardware forming the interface between the processor and the
memory system. For example, suppose a processor always fetches 8 bytes from
memory with an address that must be a multiple of 8. If we can guarantee that any
double will be aligned to have its address be a multiple of 8, then the value can
be read or written with a single memory operation. Otherwise, we may need to
perform two memory accesses, since the object might be split across two 8-byte
memory blocks.

    The IA32 hardware will work correctly regardless of the alignment of data.
However, Intel recommends that data be aligned to improve memory system
performance. Linux follows an alignment policy where 2-byte data types (e.g.,
short) must have an address that is a multiple of 2, while any larger data types
(e.g., int, int *, float, and double) must have an address that is a multiple of
4. Note that this requirement means that the least significant bit of the address of
an object of type short must equal zero. Similarly, any object of type int, or any
pointer, must be at an address having the low-order 2 bits equal to zero.

    Library routines that allocate memory, such as malloc, must be designed
so that they return a pointer that satisfies the worst-case alignment restriction
for the machine it is running on, typically 4 or 8. For code involving structures,
the compiler may need to insert gaps in the field allocation to ensure that each
structure element satisfies its alignment requirement. The structure then has some
required alignment for its starting address.

    In addition, the compiler may need to add padding to the end of the structure
so that each element in an array of structures will satisfy its alignment requirement.

-------------------------------------------------------------------------------
Conclusion

1. K-byte data types must have an address that is a multiple of K.
2. Bytes of structure must be a multiple of P. P is max size of element in structure.
-------------------------------------------------------------------------------

*/
#include <stdio.h>
#include <stddef.h>
#include <assert.h>

/* x64 gcc */
#define DOUBLE_LEN  8
#define FLOAT_LEN   4
#define INT_LEN     4
#define LONG_LEN    8
#define SHORT_LEN   2
#define CHAR_LEN    1


struct A {
    int a;  // [0, 3]
};

struct B {
    int a;  // [0, 3]
    char b; // [4]
    // 3 bytes padding [5, 7]
    // char c[3];
};

struct C {
    char a; // [0]
    // 3 bytes padding [1, 3]
    int b;  // [4, 7]
};

struct D {
    char a; // [0]
};

struct E {
    char a; // [0]
    char b; // [1]
};

struct G {
    int     a; // [0, 3]
    short   b; // [4, 5]
    char    c; // [6]
    // 1 bytes padding [7]
    double  d; // [8, 15]
    float   e; // [16, 19]
    // 4 bytes padding [20, 23]
};

struct H {
    double  a; // [0, 7]
    int     b; // [8, 11]
    short   c; // [12, 13]
    char    d; // [14]
    // 1 bytes padding [15]
    float   e; // [16, 19]
    // 4 bytes padding [20, 23]
};

struct I {
    char    a; // [0]
    // 1 bytes padding [1]
    short   b; // [2, 3]
    int     c; // [4, 7]
    float   d; // [8, 11]
    // 4 bytes padding [12, 15]
    double  e; // [16, 23]
};

// Do not alignment
#pragma pack(push, 1)
struct J {
    int     a; // [0. 3]
    short   b; // [4, 5]
    double  c; // [6, 13]
    char    d; // [14]
    float   e; // [15, 18]
};
#pragma pack(pop)


struct K_ {
    int a; // [0, 3]
};

struct K {
    char a; // [0]
    char b; // [1]
    union {
        char c[256]; // [4, 263] ?
        struct K_ d; // [4, 11]  ?
    } u;
};

struct L_ {
    int a; // [0, 3]
};

struct L {
    // explicit alignment
    char a[8]; // [0, 7]
    union {
        char b[256]; // [8, 263]
        struct L_ c; // [8, 11]
    } u;
};

struct O {
    int     a; // [0. 3]
    short   b; // [4, 5]
    // 2 bytes padding [6, 7]
    double  c; // [8, 15]
    char    d; // [16]
    // 3 bytes padding [17, 19]
    float   e; // [20, 23]
}; // contrast with above

union max_align {
    double  a;
    long    b;
    void*   c;
};

struct Y {
    char a;
    char b;
};

union Z {
    union max_align dummy;
    struct Y y;
};

int main(int argc, char const* argv[])
{
    assert(sizeof(double) == DOUBLE_LEN);
    assert(sizeof(float)  == FLOAT_LEN);
    assert(sizeof(int)    == INT_LEN);
    assert(sizeof(long)   == LONG_LEN);
    assert(sizeof(short)  == SHORT_LEN);
    assert(sizeof(char)   == CHAR_LEN);

    // |4|
    assert(offsetof(struct A, a) == 0);
    assert(__alignof__(struct A) == INT_LEN);
    assert(sizeof(struct A) == 4);

    // |4|1xxx|
    assert(offsetof(struct B, a) == 0);
    assert(offsetof(struct B, b) == 4);
    assert(__alignof__(struct B) == INT_LEN);
    assert(sizeof(struct B) == 8);

    // |1xxx|4|
    assert(offsetof(struct C, a) == 0);
    assert(offsetof(struct C, b) == 4);
    assert(__alignof__(struct C) == INT_LEN);
    assert(sizeof(struct C) == 8);

    // |1|
    assert(offsetof(struct D, a) == 0);
    assert(__alignof__(struct D) == CHAR_LEN);
    assert(sizeof(struct D) == 1);

    // |1|1|
    assert(offsetof(struct E, a) == 0);
    assert(offsetof(struct E, b) == 1);
    assert(__alignof__(struct E) == CHAR_LEN);
    assert(sizeof(struct E) == 2);

    // |4|2|1x|8|4xxxx|
    assert(offsetof(struct G, a) == 0);
    assert(offsetof(struct G, b) == 4);
    assert(offsetof(struct G, c) == 6);
    assert(offsetof(struct G, d) == 8);
    assert(offsetof(struct G, e) == 16);
    assert(__alignof__(struct G) == DOUBLE_LEN);
    assert(sizeof(struct G) == 24);

    // |8|4|2|1x|4xxxx|
    assert(offsetof(struct H, a) == 0);
    assert(offsetof(struct H, b) == 8);
    assert(offsetof(struct H, c) == 12);
    assert(offsetof(struct H, d) == 14);
    assert(offsetof(struct H, e) == 16);
    assert(__alignof__(struct H) == DOUBLE_LEN);
    assert(sizeof(struct H) == 24);

    // |1x|2|4|4xxxx|8|
    assert(offsetof(struct I, a) == 0);
    assert(offsetof(struct I, b) == 2);
    assert(offsetof(struct I, c) == 4);
    assert(offsetof(struct I, d) == 8);
    assert(offsetof(struct I, e) == 16);
    assert(__alignof__(struct I) == DOUBLE_LEN);
    assert(sizeof(struct I) == 24);

    // |4|2|1|8|4|
    assert(offsetof(struct J, a) == 0);
    assert(offsetof(struct J, b) == 4);
    assert(offsetof(struct J, c) == 6);
    assert(offsetof(struct J, d) == 14);
    assert(offsetof(struct J, e) == 15);
    assert(__alignof__(struct J) == 1);
    assert(sizeof(struct J) == 19);

    assert(offsetof(struct K, a) == 0);
    assert(offsetof(struct K, b) == 1);
    /* assert(offsetof(struct K, u.c) == 4); */
    /* assert(offsetof(struct K, u.d) == 4); */

    assert(offsetof(struct L, a) == 0);
    assert(offsetof(struct L, u.b) == 8);
    assert(offsetof(struct L, u.c) == 8);
    assert(offsetof(struct L, u.c.a) == 8);
    assert(sizeof(struct L) == 256 + 8);

    assert(offsetof(struct O, a) == 0);
    assert(offsetof(struct O, b) == 4);
    assert(offsetof(struct O, c) == 8);
    assert(offsetof(struct O, d) == 16);
    assert(offsetof(struct O, e) == 20);
    assert(__alignof__(struct O) == 8);
    assert(sizeof(struct O) == 24);

    assert(sizeof(union max_align) == 8);

    assert(__alignof__(struct Y) == CHAR_LEN);
    assert(sizeof(struct Y) == 2);
    assert(sizeof(union Z) == 8);


    return 0;
}
