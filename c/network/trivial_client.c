#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

int main(int argc, char const* argv[]) {
    const char* server_ip = "127.0.0.1";
    const int server_port = 2013;

    int fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) {
        fprintf(stderr, "%s\n", strerror(errno));
        return 0;
    }

    struct sockaddr_in addr;
    addr.sin_addr.s_addr = inet_addr(server_ip);
    addr.sin_family = AF_INET;
    addr.sin_port = htons(server_port);

    int r = connect(fd, (struct sockaddr*)& addr, sizeof(struct sockaddr_in));
    if (r == -1) {
        fprintf(stderr, "%s\n", strerror(errno));
        return 0;
    }

    sleep(1);

    r = shutdown(fd, SHUT_WR);
    if (r == -1) {
        fprintf(stderr, "%s\n", strerror(errno));
        return 0;
    }

    sleep(1);

    r = close(fd);
    if (r == -1) {
        fprintf(stderr, "%s\n", strerror(errno));
        return 0;
    }

    return 0;
}
