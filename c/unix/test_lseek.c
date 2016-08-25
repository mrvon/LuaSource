#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>

/*
$ ./a.out < /etc/passwd
seek OK
$ cat < /etc/passwd | ./a.out
cannot seek
*/

int main() {
    off_t current_offset = lseek(STDIN_FILENO, 0, SEEK_CUR);

    if (current_offset == -1) {
        printf("cannot seek\n");
    } else {
        printf("seek OK\n");
    }
    return 0;
}
