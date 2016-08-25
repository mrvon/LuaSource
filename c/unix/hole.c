#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>
#include <assert.h>

/*
    $ ./a.out
    $ ls -l file.hole
     -rw-r--r-- 1 sar 16394 Nov 25 01:01 file.hole
    $ od -c file.hole
     0000000 a b c d e f g h i j \0 \0 \0 \0 \0 \0
     0000020 \0 \0 \0 \0 \0 \0 \0 \0 \0 \0 \0 \0 \0 \0 \0 \0
     *
     0040000 A B C D E F G H I J
     0040012

To prove that there is really a hole in the file, let’s compare the file we just created
with a file of the same size, but without holes:

    $ ls -ls file.hole file.nohole compare sizes
     8 -rw-r--r-- 1 sar 16394 Nov 25 01:01 file.hole
    20 -rw-r--r-- 1 sar 16394 Nov 25 01:03 file.nohole

*/

#define FILE_MODE (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)

char buf1[] = "abcdefghij";
char buf2[] = "ABCDEFGHIJ";

int main() {
    int fd;

    if ((fd = creat("file.hole", FILE_MODE)) < 0) {
        fprintf(stderr, "creat error : %s", strerror(errno));
        return 1;
    }

    // offset now is 0
    assert(lseek(fd, 0, SEEK_CUR) == 0);

    if (write(fd, buf1, 10) != 10) {
        fprintf(stderr, "buf1 write error: %s", strerror(errno));
        return 1;
    }

    // offset now is 10
    assert(lseek(fd, 0, SEEK_CUR) == 10);

    if (lseek(fd, 16384, SEEK_SET) == -1) {
        fprintf(stderr, "lseek error: %s", strerror(errno));
        return 1;
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

