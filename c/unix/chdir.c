#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
    if (argc != 2) {
        fprintf(stderr, "usage: cd directory_name\n");
        exit(1);
    }

    char buf[1024];

    int e = chdir(argv[1]);

    if (e == -1) {
        fprintf(stderr, "can't change directory to %s : %s\n", argv[1], strerror(errno));
        exit(1);
    }

    printf("PWD: %s\n", getcwd(buf, 1024));
}


