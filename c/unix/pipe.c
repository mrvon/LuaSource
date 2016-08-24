#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

// Unbuffered I/O
//
// Unbuffered I/O is provided by the functions open, read, write, lseek, and close.
// These functions all work with file descriptors.
//
// Read from the standard input and write to the standard output.
// ./a.out < infile > outfile

int main() {
    int n;
    int bfsz = 4096;
    char buf[bfsz];

    while ((n = read(STDIN_FILENO, buf, bfsz)) > 0) {
        if (write(STDOUT_FILENO, buf, n) != n) {
            printf("write error\n");
            exit(1);
        }
    }

    if (n < 0) {
            printf("read error\n");
            exit(1);
    }

    exit(0);
}
