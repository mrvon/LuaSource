#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <errno.h>

#include <stdio.h>
#include <string.h>

int main() {
    struct addrinfo hints;
    struct addrinfo* result;
    struct addrinfo* rp;

    const char* host = "0.0.0.0";
    const char* port = "5000";

    if (getaddrinfo(host, port, NULL, &result) != 0) {
        fprintf(stderr, "%s\n", strerror(errno));
        return 0;
    }

    for (rp = result; rp != NULL; rp = rp->ai_next) {
        fprintf(stdout,
                "-----------------------------------------\n"
                "ai_flags(%d)\n"
                "ai_family(%d)\n"
                "ai_sockettype(%d)\n"
                "ai_protocol(%d)\n",
                rp->ai_flags,
                rp->ai_family,
                rp->ai_socktype,
                rp->ai_protocol);
    }

    return 0;
}
