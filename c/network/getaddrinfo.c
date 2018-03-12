#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <errno.h>

#include <stdio.h>
#include <string.h>

int main() {
    struct addrinfo ai_hints;
    struct addrinfo* ai_list;
    struct addrinfo* ai_ptr;

	memset(&ai_hints, 0, sizeof(ai_hints));

    const char* host = "www.163.com";

    if (getaddrinfo(host, NULL, NULL, &ai_list) != 0) {
        fprintf(stderr, "%s\n", strerror(errno));
        return 0;
    }

    for (ai_ptr = ai_list; ai_ptr != NULL; ai_ptr = ai_ptr->ai_next) {
        struct sockaddr_in *addr = (struct sockaddr_in*)ai_ptr->ai_addr;
        fprintf(stdout, "%d %d %d %d %s\n",
                ai_ptr->ai_flags,
                ai_ptr->ai_family,
                ai_ptr->ai_socktype,
                ai_ptr->ai_protocol,
                inet_ntoa(addr->sin_addr));
    }

    freeaddrinfo(ai_list);

    return 0;
}
