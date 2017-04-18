#include <sys/types.h>
#include <wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

void errno_abort(const char* message) {
    printf("%s - %s\n", message, strerror(errno));
    exit(0);
}

int main(int argc, char *argv[]) {
    int status;
    char line[128];
    int seconds;
    pid_t pid;
    char message[64];

    while (1) {
        printf("Alarm> ");
        if (fgets(line, sizeof(line), stdin) == NULL) {
            exit(0);
        }
        if (strlen(line) <= 1) {
            continue;
        }
        /*
         * Parse input line into seconds (%d) and a message
         * (%64[^\n]), consisting of up to 64 characters
         * separated from the seconds by whitespace.
         */
        if (sscanf(line, "%d %64[^\n]", &seconds, message) < 2) {
            fprintf(stderr, "Bad command\n");
        } else {
            pid = fork();
            if (pid == (pid_t)-1) {
                errno_abort("fork");
            }
            if (pid == (pid_t)0) {
                // In the child, wait and then print a message
                sleep(seconds);
                printf("(%d) %s\n", seconds, message);
                exit(0);
            } else {
                // In the parent, call waitpid() to collect children that have
                // already terminated.
                do {
                    pid = waitpid((pid_t)-1, NULL, WNOHANG); // return immediately
                    if (pid == (pid_t)-1) {
                        errno_abort("wait for child");
                    }
                } while (pid != (pid_t)0);
            }
        }
    }
}
