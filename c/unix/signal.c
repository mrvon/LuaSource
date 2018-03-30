// killall -s SIGUSR1 a.out
// killall -s SIGUSR2 a.out

#include <stdio.h>
#include <signal.h>

static void sig_handler_1(int sig) {
    printf("Old SIG %d\n", sig);
}

static void sig_handler_2(int sig) {
    printf("New SIG %d\n", sig);
}

int main() {
    // LEGACY
    signal(SIGUSR1, sig_handler_1);

    // POSIX
    struct sigaction sa;
    sa.sa_flags = 0;
    sa.sa_handler = sig_handler_2;
    sigemptyset(&sa.sa_mask);
    sigaction(SIGUSR2, &sa, NULL);

    while (1) {
        int x;
        scanf("%d", &x);
    }

    return 0;
}
