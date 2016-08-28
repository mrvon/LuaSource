#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>

int main() {
    fprintf(stderr, "EACCES: %s\n", strerror(EACCES));

    errno = ENOENT;
    perror("fucking world");

    exit(0);
}
