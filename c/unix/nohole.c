#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>
#include <assert.h>

#define FILE_MODE (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)

char buf1[] = "abcdefghij";
char buf2[] = "ABCDEFGHIJ";

int main() {
    int fd;
    int i;

    if ((fd = creat("file.nohole", FILE_MODE)) < 0) {
        fprintf(stderr, "creat error : %s", strerror(errno));
        return 1;
    }

    if (write(fd, buf1, 10) != 10) {
        fprintf(stderr, "buf1 write error: %s", strerror(errno));
        return 1;
    }

    for (i = 0; i < 16374; i++) {
        if (write(fd, "1", 1) != 1) {
            fprintf(stderr, "write error: %s", strerror(errno));
            return 1;
        }
    }

    // offset now is 16384
    assert(lseek(fd, 0, SEEK_CUR) == 16384);

    if (write(fd, buf2, 10) != 10) {
        fprintf(stderr, "buf2 write error: %s", strerror(errno));
        return 1;
    }

    // offset now is 16394
    assert(lseek(fd, 0, SEEK_CUR) == 16394);

    return 0;
}

