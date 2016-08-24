#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <errno.h>
#include <string.h>

int main(int argc, char* argv[]) {
    DIR *dp;
    struct dirent *dirp;

    if (argc != 2) {
        fprintf(stderr, "usage: ls directory_name\n");
        exit(1);
    }

    if ((dp = opendir(argv[1])) == NULL) {
        fprintf(stderr, "can't not open %s : %s\n", argv[1], strerror(errno));
        exit(1);
    }

    while ((dirp = readdir(dp)) != NULL) {
        printf("%s\n", dirp->d_name);
    }

    closedir(dp);
    exit(0);
}
