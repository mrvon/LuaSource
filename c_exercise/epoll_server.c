/* bool */
#include <stdbool.h>

/* epoll */
#include <netdb.h>
#include <unistd.h>
#include <sys/epoll.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <fcntl.h>

/* thread */
#include <pthread.h>

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <errno.h>

#define BACKLOG 32

/* ---------------------------------------------------------------------------*/
/* simple interface */

struct event {
	void* s;        /* application socket */
	bool read;      /* can read flag */
	bool write;     /* can write flag */
};

static bool
engine_invalid(int epoll_fd) {
    return epoll_fd == -1;
}

static int
engine_create() {
    return epoll_create(1024);
}

static void
engine_release(int epoll_fd) {
    close(epoll_fd);
}

static int
engine_add(int epoll_fd, int socket_fd, void* ud) {
    struct epoll_event ev;
    ev.events = EPOLLIN;
    ev.data.ptr = ud;

    if (epoll_ctl(epoll_fd, EPOLL_CTL_ADD, socket_fd, &ev) == -1) {
        return 1;
    }
    else {
        return 0;
    }
}

static void
engine_del(int epoll_fd, int socket_fd) {
    epoll_ctl(epoll_fd, EPOLL_CTL_DEL, socket_fd, NULL);
}

static void
engine_write(int epoll_fd, int socket_fd, void* ud, bool enable) {
    struct epoll_event ev;
    ev.events = EPOLLIN | (enable ? EPOLLOUT : 0);
    ev.data.ptr = ud;
    epoll_ctl(epoll_fd, EPOLL_CTL_MOD, socket_fd, &ev);
}

static int
engine_wait(int epoll_fd, struct event *e, int max) {
    struct epoll_event ev[max];
    int n = epoll_wait(epoll_fd, ev, max, -1);
    int i;
    for (i = 0; i < n; ++i) {
        unsigned flag = ev[i].events;

        e[i].s = ev[i].data.ptr;
        e[i].read = (flag & EPOLLIN) != 0;
        e[i].write = (flag & EPOLLOUT) != 0;
    }

    return n;
}

static void
engine_noblocking(int socket_fd) {
    int flag = fcntl(socket_fd, F_GETFL, 0);
    if (flag == -1) {
        return;
    }

    fcntl(socket_fd, F_SETFL, flag | O_NONBLOCK);
}

/* ---------------------------------------------------------------------------*/

#define MAX_EVENT 64

/* application level socket */
struct socket {
    int type;           /* socket type */
    int fd;             /* socket fd */
};

struct socket_server {
    int epoll_fd;       /* engine fd */
    int send_command_fd;/* send command to engine */
    int recv_command_fd;/* recv command to engine */
    int event_count;    /* totol count */
    int event_index;    /* current process index */
    struct event ev[MAX_EVENT];
};

#define SOCKET_TYPE_INVALID -1
#define SOCKET_TYPE_LISTEN  1

#define FD_TYPE_PIPE        0

static struct socket*
new_socket(int type, int fd) {
    /* TODO SHOULD USE HASH TABLE */
    struct socket* s = malloc(sizeof(struct socket));
    assert(s);

    s->type = type;
    s->fd = fd;

    return s;
}

static struct socket_server*
create_socket_server() {
    int pipe_fd[2];
    int epoll_fd = engine_create();

    if (engine_invalid(epoll_fd)) {
        fprintf(stderr, "create epoll failed.\n");
        return NULL;
    }

    if (pipe(pipe_fd)) {
        engine_release(epoll_fd);
        fprintf(stderr, "create pipe pair failed.\n");
        return NULL;
    }

    /* It's not a real socket */
    struct socket* recv_socket = new_socket(FD_TYPE_PIPE, pipe_fd[0]);

    if (engine_add(epoll_fd, pipe_fd[0], recv_socket)) {
        fprintf(stderr, "add pipe recv fd to epoll failed.\n");
        close(pipe_fd[0]);
        close(pipe_fd[1]);
        engine_release(epoll_fd);
        return NULL;
    }

    struct socket_server* ss = malloc(sizeof(*ss));
    assert(ss);

    ss->epoll_fd = epoll_fd;
    ss->recv_command_fd = pipe_fd[0];
    ss->send_command_fd = pipe_fd[1];
    ss->event_count = 0;
    ss->event_index = 0;
	memset(&ss->ev, 0, sizeof(ss->ev));

    return ss;
}

static void
close_socket_server(struct socket_server* ss) {
    close(ss->send_command_fd);
    close(ss->recv_command_fd);
    engine_release(ss->epoll_fd);
}

/* #pragma pack(push, 1) */

struct listen_command {
    int fd;    /* listen fd */
};

struct engine_command {
    uint8_t type;
    uint8_t len;
    union {
        char buffer[256];
        struct listen_command listen;
    } u;
};

/* #pragma pack(pop) */

static void
send_engine_command(struct socket_server* ss, struct engine_command* cmd, uint8_t type, uint8_t len) {
    cmd->type = type;
    cmd->len = len;

    for (;;) {
        int n = write(ss->send_command_fd, cmd, len + 2);
        if (n < 0) {
            if (errno != EINTR) {
                fprintf(stderr, "send engine command error %s.\n", strerror(errno));
            }
            continue;
        }
        assert(n == len + 2);
        return;
    }
}

static void
block_readpipe(int pipe_fd, void* buffer, int sz) {
    for (;;) {
        int n = read(pipe_fd, buffer, sz);
        if (n < 0) {
            if (errno == EINTR) {
                continue;
            }
            fprintf(stderr, "read pipe error %s.\n", strerror(errno));
            return;
        }
        assert(n == sz);
        return;
    }
}

static void
exec_listen_command(struct listen_command* command) {
    fprintf(stdout, "exec listen command\n");
    fprintf(stdout, "fd = %d\n", command->fd);
}

static void
process_engine_command(struct event* e, struct socket* s) {
    if (e->read) {
        uint8_t header[2];
        uint8_t buffer[256];

        block_readpipe(s->fd, header, sizeof(header));

        int type = header[0];
        int len = header[1];

        block_readpipe(s->fd, buffer, len);

        switch (type) {
            case 'L':
                exec_listen_command((struct listen_command*)buffer);
                return;
            default:
                fprintf(stderr, "unknown engine command.\n");
                return;
        }
    }
}

static int
raw_bind(const char* host, int port, int protocol, int* family) {
    int fd;
    int status;
    int reuse = 1;
    struct addrinfo ai_hints;
    struct addrinfo *ai_list = NULL;
    char portstr[16];

    if (host == NULL || host[0] == 0) {
        /* INADDR_ANY */
        host = "0.0.0.0";
    }
    sprintf(portstr, "%d", port);
    memset(&ai_hints, 0, sizeof(ai_hints));
    ai_hints.ai_family = AF_UNSPEC;
    if (protocol == IPPROTO_TCP) {
        ai_hints.ai_socktype = SOCK_STREAM;
    } else {
        ai_hints.ai_socktype = SOCK_DGRAM;
    }
    ai_hints.ai_protocol = protocol;

    status = getaddrinfo(host, portstr, &ai_hints, &ai_list);
    if (status != 0) {
        return -1;
    }

    *family = ai_list->ai_family;

    fd = socket(*family, ai_list->ai_socktype, 0);
    if (fd < 0) {
        goto _failed_fd;
    }
    if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, (void*)&reuse, sizeof(int)) == -1) {
        goto _failed;
    }

    status = bind(fd, (struct sockaddr *)ai_list->ai_addr, ai_list->ai_addrlen);
    if (status != 0) {
        goto _failed;
    }

    freeaddrinfo(ai_list);
    return fd;
_failed:
    close(fd);
_failed_fd:
    freeaddrinfo(ai_list);
    return -1;
}

static int
raw_listen(const char* host, int port, int backlog) {
    int family = 0;
    int listen_fd = raw_bind(host, port, IPPROTO_TCP, &family);
    if (listen_fd < 0) {
        return -1;
    }
    if (listen(listen_fd, backlog) == -1) {
        close(listen_fd);
        return -1;
    }
    return listen_fd;
}

/* ---------------------------------------------------------------------------*/
int
socket_listen(struct socket_server* ss, const char* host, int port, int backlog) {
    int listen_fd = raw_listen(host, port, backlog);
    if (listen_fd < 0) {
        return -1;
    }

    struct engine_command cmd;
    cmd.u.listen.fd = listen_fd;

    printf("listen_fd: %d\n", listen_fd);

    send_engine_command(ss, &cmd, 'L', sizeof(cmd.u.listen));
}

static int
network_main_loop(struct socket_server* ss) {
    for (;;) {

        /* all event have process */
        if (ss->event_index == ss->event_count) {
            ss->event_count = engine_wait(ss->epoll_fd, ss->ev, MAX_EVENT);
            ss->event_index = 0;

            if (ss->event_count <= 0) {
                ss->event_count = 0;

                return -1;
            }
        }

        struct event* e = &ss->ev[ss->event_index++];
        struct socket* s = e->s;

        if (s == NULL) {
            continue;
        }

        switch (s->type) {
            case FD_TYPE_PIPE:
                process_engine_command(e, s);
                break;
        }

    }
}

static int
network_main_loop_wrapper(void* ud) {
    struct socket_server* ss = (struct socket_server*)ud;

    network_main_loop(ss);
}

static void*
thread_network(void* ud) {
    for(;;) {
        network_main_loop_wrapper(ud);
    }
}

static void
create_thread(pthread_t *thread, void *(*start_routine) (void *), void *arg) {
	if (pthread_create(thread, NULL, start_routine, arg)) {
		fprintf(stderr, "Create thread failed");
		exit(1);
	}
}

int main() {
    struct socket_server* ss = create_socket_server();
    if (ss == NULL) {
        return;
    }

    pthread_t network;
    create_thread(&network, thread_network, ss);

    socket_listen(ss, "127.0.0.1", 5000, BACKLOG);

    pthread_join(network, NULL);
    close_socket_server(ss);

    return 0;
}
