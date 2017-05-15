#include <stdio.h>
#include <stdint.h>

#define uvnan    0x7FF8000000000001
#define uvinf    0x7FF0000000000000
#define uvneginf 0xFFF0000000000000

int main() {
    uint64_t unan = uvnan;
    uint64_t uinf = uvinf;
    uint64_t uneginf = uvneginf;

    double* nan = (double*)&unan;
    double* inf = (double*)&uinf;
    double* neginf = (double*)&uneginf;

    printf("%f\n", *nan);
    printf("%f\n", *inf);
    printf("%f\n", *neginf);
    printf("%f\n", 0.0/0.0);

    return 0;
}
