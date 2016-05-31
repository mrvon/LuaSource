#include <stdio.h>
#include "atomic.h"

int main(int argc, char const* argv[])
{
    unsigned int k = 0;

    printf("K = %u\n", k);

    printf("Inc and fetch %u\n", ATOM_INC(&k));
    printf("Dec and fetch %u\n", ATOM_DEC(&k));

    printf("K = %u\n", k);

    printf("Fetch and inc %u\n", ATOM_FINC(&k));
    printf("Fetch and dec %u\n", ATOM_FDEC(&k));

    printf("K = %u\n", k);

    printf("Add and fetch %u\n", ATOM_ADD(&k, 1024));
    printf("Sub and fetch %u\n", ATOM_SUB(&k, 1024));

    printf("K = %u\n", k);

    printf("Add and fetch %u\n", ATOM_ADD(&k, 0xff));
    printf("And and fetch %u\n", ATOM_AND(&k, 0x0));
    printf("And and fetch %u\n", ATOM_OR(&k, 0xf));

    printf("K = %u\n", k);

    if (ATOM_CAS(&k, 0, 1)) {
        printf("Atom compare and swap ok!\n");
    }
    else {
        printf("Atom compare and swap failed!\n");
    }

    printf("K = %u\n", k);

    return 0;
}
