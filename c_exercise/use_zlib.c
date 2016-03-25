#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <zlib.h>

// gcc -std=gnu99 use_zlib.c -lz

void buff_print(const char* buff, unsigned long len) {
	static char hex[] = "0123456789abcdef";

    printf("%ld\n", len);
    for (int i = 0; i < len; ++i) {
        char byte = buff[i];

        printf("%c", hex[(byte & 0xF0) >> 4]);
        printf("%c", hex[(byte & 0x0F) >> 0]);
    }
    printf("\n");
}

int main(int argc, char const* argv[]) {

    char source[] = "fuck you every day";

    unsigned long source_len = strlen(source) + 1;
    unsigned long dest_len = 0;

    buff_print(source, source_len);

    dest_len = compressBound(source_len);

    char* dest = (char*)malloc(dest_len);
    assert(dest);

    int status = compress(dest, &dest_len, source, source_len);

    if (status != Z_OK) {
        printf("compress error (%d)!\n", status);
        return 0;
    }

    buff_print(dest, dest_len);

    unsigned long ori_len = source_len;
    char* ori = (char*)malloc(source_len);
    assert(ori);

    status = uncompress(ori, &ori_len, dest, dest_len);

    if (status != Z_OK) {
        printf("uncompress error (%d)!\n", status);
        return 0;
    }

    buff_print(ori, ori_len);

    return 0;
}
