#include <stdio.h>
#include <stdint.h>

uint32_t little_endian_int(uint32_t n) {
    union {
        uint32_t p;
        uint8_t q[4];
    } u;

    u.p = n;
    return u.q[0] | (u.q[1] << 8) | (u.q[2] << 16) | (u.q[3] << 24);
}

int main() {
    FILE* f = fopen("./png.bin", "rb");
    if (f == NULL) {
        printf("open file failed\n");
        return 0;
    }

    uint32_t n;
    uint32_t h;
    uint32_t w;

    uint32_t bfsz = 8192;
    uint32_t buff[bfsz];

    for (;;) {
        int s = fread(&n, sizeof(n), 1, f);
        if (s == 0) {
            break;
        }

        if (n >= bfsz) {
            break;
        }

        fread(buff, 1, n, f);
        printf("%s ", (char*)buff);

        fread(&h, sizeof(h), 1, f);
        printf("%u ", little_endian_int(h));

        fread(&w, sizeof(w), 1, f);
        printf("%u\n", little_endian_int(w));
    }

    fclose(f);
}
