#include <pthread.h>
#include <wait.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

void errno_abort(const char* message) {
    printf("%s - %s\n", message, strerror(errno));
    exit(0);
}

typedef struct alarm_tag {
    int     seconds;
    char    messages[64];
} alarm_t;


void* alarm_thread(void *arg) {
    alarm_t *alarm = (alarm_t*)arg;
    int status;

    status = pthread_detach(pthread_self());
    if (status != 0) {
        errno_abort("Detach thread");
    }
    sleep(alarm->seconds);
    printf("(%d) %s\n", alarm->seconds, alarm->messages);
    free(alarm);
    return NULL;
}

int main() {
    int status;
    char line[128];
    alarm_t *alarm;
    pthread_t thread;

    while (1) {
        printf("Alarm> ");
        if (fgets(line, sizeof(line), stdin) == NULL) {
            exit(0);
        }
        if (strlen(line) <= 1) {
            continue;
        }
        alarm = (alarm_t*)malloc(sizeof(alarm_t));
        if (alarm == NULL) {
            errno_abort("Allocate alarm");
        }
        /*
         * Parse input line into seconds (%d) and a message
         * (%64[^\n]), consisting of up to 64 characters
         * separated from the seconds by whitespace.
         */
        if (sscanf(line, "%d %64[^\n]", &alarm->seconds, alarm->messages) < 2) {
            fprintf(stderr, "Bad command\n");
            free(alarm);
        } else {
            status = pthread_create(&thread, NULL, alarm_thread, alarm);
            if (status != 0) {
                errno_abort("Create alarm thread");
            }
        }
    }
}
