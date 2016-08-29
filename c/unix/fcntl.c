#include <fcntl.h>
#include <stdio.h>

/*
    $ ./a.out 0 < /dev/tty
    read only
    $ ./a.out 1 > temp.foo
    $ cat temp.foo
    write only
    $ ./a.out 2 2>>temp.foo
    write only, append
    $ ./a.out 5 5<>temp.foo
    read write

    The clause 5<>temp.foo opens the file temp.foo for reading and writing on file
    descriptor 5.
*/

int main(int argc, char** argv) {
    int val;

    if (argc != 2) {
        printf("usage: a.out <descriptor#>\n");
        return 1;
    }

    if ((val = fcntl(atoi(argv[1]), F_GETFL, 0)) < 0) {
        printf("fcntl error for fd %d\n", atoi(argv[1]));
        return 1;
    }

    switch (val & O_ACCMODE) {
        case O_RDONLY:
            printf("read only");
            break;

        case O_WRONLY:
            printf("write only");
            break;

        case O_RDWR:
            printf("read write");
            break;

        default:
            printf("unknown access mode\n");
            return 1;
    }

    if (val & O_APPEND) {
        printf(", append");
    }

    if (val & O_NONBLOCK) {
        printf(", nonblocking");
    }

    if (val & O_SYNC) {
        printf(", synchronous writes");
    }

    printf("\n");
    return 0;
}
