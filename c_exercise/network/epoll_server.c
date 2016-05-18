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

/* atomic function */
#include "atomic.h"

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

static void
socket_keepalive(int fd) {
	int keepalive = 1;
	setsockopt(fd, SOL_SOCKET, SO_KEEPALIVE, (void *)&keepalive , sizeof(keepalive));
}

/* ---------------------------------------------------------------------------*/

#define MAX_EVENT   64
#define MAX_SOCKET  (1<<16)

/* application level socket */
struct socket {
    int id;             /* socket id */
    int fd;             /* socket fd */
    int type;           /* socket type */
};

struct socket_server {
    int epoll_fd;       /* engine fd */
    int send_command_fd;/* send command to engine */
    int recv_command_fd;/* recv command to engine */
    int event_count;    /* totol count */
    int event_index;    /* current process index */
    int alloc_id;       /* for alloc application socket id */
    struct event event_list[MAX_EVENT];     /* process event list */
    struct socket socket_map[MAX_SOCKET];   /* application socket map */
};

struct socket_message {
    int id; /* socket id */
    int ud; /* for accept message, ud is accept id; for data, ud is size of data; */
};

#define SOCKET_TYPE_INVALID     0
#define SOCKET_TYPE_RESERVE     1
#define SOCKET_TYPE_PLISTEN     2
#define SOCKET_TYPE_LISTEN      3
#define SOCKET_TYPE_CONNECTING  4
#define SOCKET_TYPE_CONNECTED   5
#define SOCKET_TYPE_HALFCLOSE   6
#define SOCKET_TYPE_PACCEPT     7
#define SOCKET_TYPE_BIND        8
#define SOCKET_TYPE_PIPE        9

#define SOCKET_DATA     0
#define SOCKET_CLOSE    1
#define SOCKET_OPEN     2
#define SOCKET_ACCEPT   3
#define SOCKET_ERROR    4
#define SOCKET_EXIT     5
#define SOCKET_UDP      6

#define HASH_ID(id) (((unsigned)id) % MAX_SOCKET)

static int
generate_id(struct socket_server* ss) {
    int i;

    for (i = 0; i < MAX_SOCKET; ++i) {
        int id = ATOM_INC(&(ss->alloc_id));
        if (id < 0) {
            id = ATOM_AND(&(ss->alloc_id), 0x7fffffff);
        }

        struct socket* s = &ss->socket_map[HASH_ID(id)];

        /* Have found a unuse socket struct */
        if (s->type == SOCKET_TYPE_INVALID) {
            /* Try to lock it */
            if (ATOM_CAS(&s->type, SOCKET_TYPE_INVALID, SOCKET_TYPE_RESERVE)) {
                /* Lock it successful */
                s->id = id;
                s->fd = -1;
                return id;
            } else {
                /* Lock by other thread, retry it. */
                --i;
            }
        }
    }

    return -1;
}

static struct socket*
new_socket(struct socket_server* ss, int id, int fd, int type, int is_add) {
    struct socket* s = &ss->socket_map[HASH_ID(id)];
    assert(s->type == SOCKET_TYPE_RESERVE);

    if (is_add) {
        if (engine_add(ss->epoll_fd, fd, s)) {
            s->type = SOCKET_TYPE_INVALID;
            return NULL;
        }
    }

    s->id = id;
    s->fd = fd;
    s->type = type;

    return s;
}

static struct socket_server*
socket_server_create() {
    int pipe_fd[2];
    int epoll_fd = engine_create();

    if (engine_invalid(epoll_fd)) {
        fprintf(stderr, "SocketEngine: create epoll failed.\n");
        return NULL;
    }

    if (pipe(pipe_fd)) {
        engine_release(epoll_fd);
        fprintf(stderr, "SocketEngine: create pipe pair failed.\n");
        return NULL;
    }

    struct socket_server* ss = malloc(sizeof(*ss));
    assert(ss);

    ss->epoll_fd = epoll_fd;
    ss->recv_command_fd = pipe_fd[0];
    ss->send_command_fd = pipe_fd[1];
    ss->event_count = 0;
    ss->event_index = 0;
    ss->alloc_id = 0;
	memset(&ss->event_list, 0, sizeof(ss->event_list));

    int i;
    for (i = 0; i < MAX_SOCKET; ++i) {
        struct socket* s = &ss->socket_map[i];
        s->type = SOCKET_TYPE_INVALID;
    }

    /* It's not a real socket */
    int id = generate_id(ss);
    if (id < 0) {
        goto _failed;
    }

    struct socket* s = new_socket(ss, id, pipe_fd[0], SOCKET_TYPE_PIPE, true);
    if (s == NULL) {
        goto _failed;
    }

    return ss;

_failed:
    fprintf(stderr, "SocketEngine: add pipe recv fd to epoll failed.\n");
    close(pipe_fd[0]);
    close(pipe_fd[1]);
    engine_release(epoll_fd);
    free((void*)ss);
    return NULL;
}

static void
socket_server_release(struct socket_server* ss) {
    int i;
    for (i = 0; i < MAX_SOCKET; ++i) {
        struct socket*s = &ss->socket_map[i];
        if (s->type != SOCKET_TYPE_RESERVE) {
            /* TODO */
            /* force_close(); */
        }
    }
    close(ss->send_command_fd);
    close(ss->recv_command_fd);
    engine_release(ss->epoll_fd);
    free((void*)ss);
}


static void
block_readpipe(int pipe_fd, void* buffer, int sz) {
    for (;;) {
        int n = read(pipe_fd, buffer, sz);
        if (n < 0) {
            if (errno == EINTR) {
                continue;
            }
            fprintf(stderr, "SocketEngine: read pipe error %s.\n", strerror(errno));
            return;
        }
        assert(n == sz);
        return;
    }
}

/* Do not alignment {
 * Because we assume that the memory of field in struct is continuous.
 * */
#pragma pack(push, 1)

struct start_command {
    int id; /* socket id */
};

struct listen_command {
    int id; /* socket id */
    int fd; /* listen fd */
};

struct engine_command {
    uint8_t type;
    uint8_t len;
    union {
        char buffer[256];
        struct start_command  start;
        struct listen_command listen;
    } u;
};

#pragma pack(pop)
/* } */

union sockaddr_all {
	struct sockaddr s;
	struct sockaddr_in v4;
	struct sockaddr_in6 v6;
};

static void
send_engine_command(struct socket_server* ss, struct engine_command* cmd, uint8_t type, uint8_t len) {
    cmd->type = type;
    cmd->len = len;

    for (;;) {
        int n = write(ss->send_command_fd, cmd, len + 2);
        if (n < 0) {
            if (errno != EINTR) {
                fprintf(stderr, "SocketEngine: send engine command error %s.\n", strerror(errno));
            }
            continue;
        }
        assert(n == len + 2);
        return;
    }
}

static int
exec_start_command(
        struct socket_server* ss,
        struct start_command* cmd,
        struct socket_message* result) {

    fprintf(stdout, "exec start command - id(%d)\n", cmd->id);

    struct socket *s = &ss->socket_map[HASH_ID(cmd->id)];
    if (s == NULL) {
        return SOCKET_ERROR;
    }

    if (s->type == SOCKET_TYPE_INVALID || s->id != cmd->id) {
        return SOCKET_ERROR;
    }

    if (s->type == SOCKET_TYPE_PLISTEN) {
        if (engine_add(ss->epoll_fd, s->fd, s)) {
            /* force_close(); */
            return SOCKET_ERROR;
        }

        s->type = SOCKET_TYPE_LISTEN;

        result->id = s->id;

        return SOCKET_OPEN;
    }

    return -1;
}

static int
exec_listen_command(
        struct socket_server* ss,
        struct listen_command* cmd,
        struct socket_message* result) {

    fprintf(stdout, "exec listen command - id(%d) fd(%d)\n", cmd->id, cmd->fd);

    struct socket* s = new_socket(ss, cmd->id, cmd->fd, SOCKET_TYPE_PLISTEN, false);
    if (s == NULL) {
        goto _failed;
    }

    return -1;

_failed:
    close(cmd->fd);
    ss->socket_map[HASH_ID(cmd->id)].type = SOCKET_TYPE_INVALID;

    return SOCKET_ERROR;
}

static int
process_engine_command(
        struct socket_server* ss,
        struct event* e,
        struct socket* s,
        struct socket_message* result) {

    if (e->read) {
        uint8_t header[2];
        uint8_t buffer[256];

        block_readpipe(s->fd, header, sizeof(header));

        int type = header[0];
        int len = header[1];

        block_readpipe(s->fd, buffer, len);

        switch (type) {
            case 'S':
                return exec_start_command(ss, (struct start_command*)buffer, result);
            case 'L':
                return exec_listen_command(ss, (struct listen_command*)buffer, result);
            default:
                fprintf(stderr, "SocketEngine: unknown engine command.\n");
                return -1;
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

static int
raw_accept(struct socket_server* ss, struct socket* s, struct socket_message* result) {
    union sockaddr_all u;
    socklen_t len = sizeof(u);
    int fd = accept(s->fd, &u.s, &len);
    if (fd < 0) {
        if (errno == EMFILE || errno == ENFILE) {
            result->id = s->id;
            result->ud = 0;
            return -1;
        } else {
            return 0;
        }
    }

    int id = generate_id(ss);
    if (id < 0) {
        close(fd);
        return 0;
    }

    socket_keepalive(fd);
    engine_noblocking(fd);

    struct socket* ns = new_socket(ss, id, fd, SOCKET_TYPE_PACCEPT, false);
    if (ns == NULL) {
        close(fd);
        return 0;
    }

    result->id = s->id;
    result->ud = id;

    return 1;
}

/* ---------------------------------------------------------------------------*/
static void
socket_server_start(struct socket_server* ss, int id) {
    struct engine_command cmd;

    cmd.u.start.id = id;

    send_engine_command(ss, &cmd, 'S', sizeof(cmd.u.start));
}

static int
socket_server_listen(struct socket_server* ss, const char* host, int port, int backlog) {
    int listen_fd = raw_listen(host, port, backlog);
    if (listen_fd < 0) {
        return -1;
    }

    struct engine_command cmd;

    int socket_id = generate_id(ss);
    if (socket_id < 0) {
        close(listen_fd);
        return socket_id;
    }

    cmd.u.listen.id = socket_id;
    cmd.u.listen.fd = listen_fd;

    send_engine_command(ss, &cmd, 'L', sizeof(cmd.u.listen));

    return socket_id;
}

static int
socket_server_poll(struct socket_server* ss, struct socket_message* result) {
    for (;;) {

        /* all event have process */
        if (ss->event_index == ss->event_count) {
            ss->event_count = engine_wait(ss->epoll_fd, ss->event_list, MAX_EVENT);
            ss->event_index = 0;

            if (ss->event_count <= 0) {
                ss->event_count = 0;

                return -1;
            }
        }

        struct event* e = &ss->event_list[ss->event_index++];
        struct socket* s = e->s;

        if (s == NULL) {
            continue;
        }

        switch (s->type) {
            case SOCKET_TYPE_CONNECTING:
                // TODO
                assert(false);
                break;
            case SOCKET_TYPE_PIPE:
                return process_engine_command(ss, e, s, result);
            case SOCKET_TYPE_LISTEN: {
                    int ok = raw_accept(ss, s, result);
                    if (ok > 0) {
                        return SOCKET_ACCEPT;
                    } else if (ok < 0) {
                        return SOCKET_ERROR;
                    }
                    // when ok == 0, retry
                }
                break;
            case SOCKET_TYPE_INVALID:
                fprintf(stderr, "SocketEngine: invalid socket\n");
                break;
            default: {
                    if (e->read) {
                    }
                    if (e->write) {
                    }
                }
                break;
        }

    }
}

static void*
thread_network(void* ud) {
    struct socket_server* ss = (struct socket_server*)ud;
    struct socket_message result;

    for(;;) {
        int type = socket_server_poll(ss, &result);

        switch (type) {
            case SOCKET_OPEN:
                fprintf(stdout, "SOCKET OPEN: (%d)\n", result.id);
                break;
            case SOCKET_ACCEPT:
                fprintf(stdout, "SOCKET ACCEPT: NEW SOCKET(%d) FROM LISTEN SOCKET(%d)\n", result.ud, result.id);
                break;
        }
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
    struct socket_server* ss = socket_server_create();
    if (ss == NULL) {
        return;
    }

    pthread_t network;
    create_thread(&network, thread_network, ss);

    int id = socket_server_listen(ss, "127.0.0.1", 5000, BACKLOG);
    socket_server_start(ss, id);

    pthread_join(network, NULL);
    socket_server_release(ss);

    return 0;
}
