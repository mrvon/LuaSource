#include <stdio.h>

typedef struct flags {
    unsigned int is_keyword : 1;
    unsigned int is_extern : 1;
    unsigned int is_static: 1;
    unsigned int is_const : 1;
} flags;

#define dbug(flag) printf("%s = %u\n", #flag, flag);

int main(int argc, char const* argv[])
{
    flags f;
    f.is_keyword = 1;
    f.is_extern = 1;
    f.is_static = 0;
    f.is_const = 0;

    dbug(f.is_keyword);
    dbug(f.is_extern);
    dbug(f.is_static);
    dbug(f.is_const);

    return 0;
}
