#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

#define MAXLINE 4096

int main() {
    char buf[MAXLINE+1];
    pid_t pid;
    int status;

    printf("%% "); // print prompt (printf requires %% to print %)

    while (fgets(buf, MAXLINE, stdin) != NULL) {
        buf[strlen(buf) - 1] = 0; // replace newline with null

        if ((pid = fork()) < 0) {
            exit(1);
        } else if (pid == 0) { // child
            // In the child, we call execlp to execute the command that was read from the
            // standard input. This replaces the child process with the new program file.
            execlp(buf, buf, (char*)0);
            fprintf(stderr, "couldn't execute: %s", buf);
            exit(127);
        }

        // We call fork to create a new process, which is a copy of the caller. We say that
        // the caller is the parent and that the newly created process is the child. Then
        // fork returns the non-negative process ID of the new child process to the parent,
        // and returns 0 to the child. Because fork creates a new process, we say that it is
        // called once—by the parent — but returns twice—in the parent and in the child.

        // parent
        if ((pid = waitpid(pid, &status, 0)) < 0) {
            fprintf(stderr, "waitpid error");
            exit(1);
        }

        // Because the child calls execlp to execute the new program file, the parent
        // wants to wait for the child to terminate. This is done by calling waitpid,
        // specifying which process to wait for: the pid argument, which is the process ID
        // of the child. The waitpid function also returns the termination status of the
        // child — the status variable — but in this simple program, we don’t do anything
        // with this value. We could examine it to determine how the child terminated.

        printf("%% ");
    }

    exit(0);
}
