/* bool */
#include <stdbool.h>

/* engine */
#ifdef __linux__
#include "epoll_api.h"
#elif __APPLE__
#include "kqueue_api.h"
#else
#error "OS do not support"
#endif

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

#define MIN_READ_BUFFER 64

// EAGAIN and EWOULDBLOCK may be not the same value. see *Man 2 socket*
#if (EAGAIN != EWOULDBLOCK)
#define AGAIN_WOULDBLOCK EAGAIN : case EWOULDBLOCK
#else
#define AGAIN_WOULDBLOCK EAGAIN
#endif


#define MAX_EVENT   64
#define MAX_SOCKET  (1<<16)

// Link-list structure
struct write_buffer {
    struct write_buffer* next;  /* link to next buffer */
    void* buffer;   /* data buffer */
    char* write_ptr;/* current write pointer */
    int sz;         /* remain size of data buffer haven't been write */
};

struct write_buff_list {
    struct write_buffer* head;
    struct write_buffer* tail;
};

/* application level socket */
struct socket {
    int id;     /* socket id */
    int fd;     /* socket fd */
    int type;   /* socket type */
    int read_buff_size;          /* read buffer size */
    int64_t write_buff_size;     /* current size of data in the write buff list */
    struct write_buff_list high; /* high priority write buffer list */
    struct write_buff_list low;  /* low priority write buffer list */
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
    char* data;
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

#define PRIORITY_HIGH   0
#define PRIORITY_LOW    1

#define HASH_ID(id) (((unsigned)id) % MAX_SOCKET)

void
socket_keepalive(int fd) {
	int keepalive = 1;
	setsockopt(fd, SOL_SOCKET, SO_KEEPALIVE, (void *)&keepalive , sizeof(keepalive));
}

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

static inline void
check_write_buff_list(struct write_buff_list* l) {
    assert(l->head == NULL);
    assert(l->tail == NULL);
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
    s->read_buff_size = MIN_READ_BUFFER;
    s->write_buff_size = 0;
    check_write_buff_list(&s->high);
    check_write_buff_list(&s->low);

    return s;
}

static void
force_close(struct socket_server* ss, struct socket* s, struct socket_message* result) {
    result->id = s->id;
    result->ud = 0;
    result->data = NULL;

    if (s->type == SOCKET_TYPE_INVALID) {
        return;
    }

    assert(s->type != SOCKET_TYPE_RESERVE);

    if (s->type != SOCKET_TYPE_PACCEPT && s->type != SOCKET_TYPE_PLISTEN) {
        engine_del(ss->epoll_fd, s->fd);
    }

    if (s->type != SOCKET_TYPE_BIND) {
        if (close(s->fd) < 0) {
            perror("SocketEngine: close socket.");
        }
    }

    s->type = SOCKET_TYPE_INVALID;
}

static inline void
clear_write_buff_list(struct write_buff_list* list) {
    list->head = NULL;
    list->tail = NULL;
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
        clear_write_buff_list(&s->high);
        clear_write_buff_list(&s->low);
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
    struct socket_message dummy;
    int i;
    for (i = 0; i < MAX_SOCKET; ++i) {
        struct socket*s = &ss->socket_map[i];
        if (s->type != SOCKET_TYPE_RESERVE) {
            force_close(ss, s, &dummy);
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
                // the call was interrupted by a signal before any data was read,
                // so retry it.
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

struct close_command {
    int id; /* socket id */
};

struct send_command {
    int id; /* socket id */
    char* buffer;
    int sz; /* buffer size */
};

struct engine_command {
    uint8_t type;
    uint8_t len;
    union {
        char buffer[256];
        struct start_command  start;
        struct listen_command listen;
        struct close_command  close;
        struct send_command   send;
    } u;
};

#pragma pack(pop)
/* } */

union sockaddr_all {
	struct sockaddr s;
	struct sockaddr_in v4;
	struct sockaddr_in6 v6;
};

static struct write_buffer*
append_send_buffer__(
        struct socket_server* ss,
        struct write_buff_list* l,
        struct send_command* cmd,
        int n) {

    struct write_buffer* buf = malloc(sizeof(*buf));
    buf->buffer = cmd->buffer;
    buf->write_ptr = cmd->buffer + n;
    buf->sz = cmd->sz;
    buf->next = NULL;

    // Link to write buffer list
    if (l->head == NULL) {
        l->head = l->tail = buf;
    } else {
        assert(l->tail != NULL);
        assert(l->tail->next == NULL);
        l->tail->next = buf;
        l->tail = buf;
    }

    return buf;
}

// append data into high priority writting queue, and wait engine send it out.
static void
append_send_buffer_high(
        struct socket_server* ss,
        struct socket* s,
        struct send_command* cmd,
        int n) {
    // n is mean write buffer offset
    struct write_buffer* buf = append_send_buffer__(ss, &s->high, cmd, n);
    // accumulate buf->sz(buff have not yet send) to write_buff_size
    s->write_buff_size += buf->sz;
}

// append data into low priority writting queue, and wait engine send it out.
static void
append_send_buffer_low(
        struct socket_server* ss,
        struct socket* s,
        struct send_command* cmd) {
    struct write_buffer* buf = append_send_buffer__(ss, &s->low, cmd, 0);
    // accumulate buf->sz(buff have not yet send) to write_buff_size
    s->write_buff_size += buf->sz;
}

static inline int
is_send_buffer_empty(struct socket* s) {
    return (s->high.head == NULL && s->low.head == NULL);
}

static inline void
write_buffer_free(struct write_buffer* buff) {
    free(buff->buffer);
    free(buff);
}

static int
send_write_buff_list(
        struct socket_server* ss,
        struct socket* s,
        struct write_buff_list* l,
        struct socket_message* result) {

    while (l->head) {
        struct write_buffer* tmp = l->head;

        for (;;) {
            int sz = write(s->fd, tmp->write_ptr, tmp->sz);
            if (sz < 0) {
                switch(errno) {
                    case EINTR:
                        continue;
                    case AGAIN_WOULDBLOCK:
                        return -1;
                }
                force_close(ss, s, result);
                return SOCKET_CLOSE;
            }

            s->write_buff_size -= sz;

            // Only send partial buffer, move write_ptr and minus sz
            if (sz != tmp->sz) {
                tmp->write_ptr += sz;
                tmp->sz -= sz;
                return -1;
            }
            break;
        }

        l->head = tmp->next;
        write_buffer_free(tmp);
    }

    l->tail = NULL;

    return -1;
}

static inline int
is_write_buff_list_uncomplete(struct write_buff_list* s) {
    struct write_buffer* buf = s->head;
    if (buf == NULL) {
        return 0;
    }

    return (void*)buf->write_ptr != buf->buffer;
}

static void
raise_write_buff_list_uncomplete(
        struct write_buff_list* high,
        struct write_buff_list* low) {

    struct write_buffer* tmp = low->head;
    low->head = tmp->next;
    if (low->head == NULL) {
        low->tail = NULL;
    }

    // move head of low priority list (tmp) to the empty high priority list
    assert(high->head == NULL);

    tmp->next = NULL;
    high->head = high->tail = tmp;
}

/*
	Each socket has two write buffer list, high priority and low priority.

	1. send high list as far as possible.
	2. If high list is empty, try to send low list.
	3. If low list head is uncomplete (send a part before), move the head of low list to empty high list (call raise_write_buff_list_uncomplete) .
	4. If two lists are both empty, turn off the event.
 */
static int
send_write_buffer(
        struct socket_server* ss,
        struct socket* s,
        struct socket_message* result) {
    // Low priority list is never uncomplete TODO
    assert(! is_write_buff_list_uncomplete(&s->low));

    // STEP 1
    if (send_write_buff_list(ss, s, &s->high, result) == SOCKET_CLOSE) {
        return SOCKET_CLOSE;
    }

    // HIGH PRIORITY List is empty
    if (s->high.head == NULL) {
        // STEP 2
        // LOW PRIORITY List is not empty
        if (s->low.head != NULL) {
            if (send_write_buff_list(ss, s, &s->low, result) == SOCKET_CLOSE) {
                return SOCKET_CLOSE;
            }
            // STEP 3
            if (is_write_buff_list_uncomplete(&s->low)) {
                raise_write_buff_list_uncomplete(&s->high, &s->low);
            }
        } else {
            // STEP 4
            engine_write(ss->epoll_fd, s->fd, s, false);

            if (s->type == SOCKET_TYPE_HALFCLOSE) {
                force_close(ss, s, result);
                return SOCKET_CLOSE;
            }
        }
    }

    return -1;
}

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
            // the call was interrupted by a signal before any data was read,
            // so retry it.
            continue;
        }
        assert(n == len + 2);
        return;
    }
}

static int
start_socket(
        struct socket_server* ss,
        struct start_command* cmd,
        struct socket_message* result) {

    result->id = cmd->id;
    result->ud = 0;
    result->data = NULL;

    fprintf(stdout, "EXEC START SOCKET CMD - id(%d)\n", cmd->id);

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

        return SOCKET_OPEN;
    } else if (s->type == SOCKET_TYPE_PACCEPT) {
        if (engine_add(ss->epoll_fd, s->fd, s)) {
            /* force_close(); */
            return SOCKET_ERROR;
        }

        s->type = SOCKET_TYPE_CONNECTED;

        return SOCKET_OPEN;
    }

    return -1;
}

static int
listen_socket(
        struct socket_server* ss,
        struct listen_command* cmd,
        struct socket_message* result) {

    fprintf(stdout, "EXEC LISTEN SOCKET CMD - id(%d) fd(%d)\n", cmd->id, cmd->fd);

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
close_socket(
        struct socket_server* ss,
        struct close_command* cmd,
        struct socket_message* result) {

    fprintf(stdout, "EXEC CLOSE SOCKET CMD - id(%d)\n", cmd->id);

    struct socket* s = &ss->socket_map[HASH_ID(cmd->id)];
    if (s->type == SOCKET_TYPE_INVALID || s->id != cmd->id) {
        result->id = cmd->id;
        result->ud = 0;
        result->data = NULL;
        return SOCKET_CLOSE;
    }

    // TODO SOCKET_TYPE_HALFCLOSE

    result->id = cmd->id;
    force_close(ss, s, result);
    return SOCKET_CLOSE;
}

static int
send_socket(
        struct socket_server* ss,
        struct send_command* cmd,
        struct socket_message* result,
        int priority) {

    fprintf(stdout, "EXEC SEND SOCKET CMD - id(%d)\n", cmd->id);

    struct socket* s = &ss->socket_map[HASH_ID(cmd->id)];
    if (s->type == SOCKET_TYPE_INVALID || s->id != cmd->id
        || s->type == SOCKET_TYPE_HALFCLOSE
        || s->type == SOCKET_TYPE_PACCEPT) {
        free((void*)cmd->buffer);
        return -1;
    }

    if (s->type == SOCKET_TYPE_PLISTEN || s->type == SOCKET_TYPE_LISTEN) {
        free((void*)cmd->buffer);
        fprintf(stderr, "SocketEngine: write to listen fd %d.\n", cmd->id);
        return -1;
    }

    if (is_send_buffer_empty(s) && s->type == SOCKET_TYPE_CONNECTED) {
        // Send directly
        int n = write(s->fd, cmd->buffer, cmd->sz);
        if (n < 0) {
            switch(errno) {
                case EINTR:
                case AGAIN_WOULDBLOCK:
                    n = 0;
                    break;
                default:
                    fprintf(stderr, "SocketEngine: write to %d (fd = %d) error:%s.\n",
                            s->id, s->fd, strerror(errno));
                    force_close(ss, s, result);
                    free((void*)cmd->buffer);
                    return SOCKET_CLOSE;
            }
        }

        if (n == cmd->sz) {
            free((void*)cmd->buffer);
            return -1;
        }

        // add to high priority list, even priority == PRIORITY_LOW,
        // because high priority is empty now!
        append_send_buffer_high(ss, s, cmd, n);
    } else {
        if (priority == PRIORITY_LOW) {
            append_send_buffer_low(ss, s, cmd);
        } else {
            append_send_buffer_high(ss, s, cmd, 0);
        }
    }

    return -1;
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
                return start_socket(ss, (struct start_command*)buffer, result);
            case 'L':
                return listen_socket(ss, (struct listen_command*)buffer, result);
            case 'K':
                return close_socket(ss, (struct close_command*)buffer, result);
            case 'D':
                return send_socket(ss, (struct send_command*)buffer, result, PRIORITY_HIGH);
            case 'P':
                return send_socket(ss, (struct send_command*)buffer, result, PRIORITY_LOW);
            default:
                fprintf(stderr, "SocketEngine: unknown engine command.\n");
                return -1;
        }
    }

    return -1;
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
    engine_nonblocking(fd);

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
/* socket server interface */

void
socket_server_start(struct socket_server* ss, int id) {
    struct engine_command cmd;

    cmd.u.start.id = id;

    send_engine_command(ss, &cmd, 'S', sizeof(cmd.u.start));
}

int
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

void
socket_server_close(struct socket_server* ss, int id) {
    struct engine_command cmd;

    cmd.u.close.id = id;

    send_engine_command(ss, &cmd, 'K', sizeof(cmd.u.close));
}

// Different from socket_server_close is that will not half close when send buffer still have data in it.
void
socket_server_shutdown() {
    // TODO
}

// return -1 when error
int64_t
socket_server_send(struct socket_server* ss, int id, const void* buffer, int sz) {
    struct socket* s = &ss->socket_map[HASH_ID(id)];
    if (s->id != id || s->type == SOCKET_TYPE_INVALID) {
        free((void*)buffer);
        return -1;
    }

    struct engine_command cmd;

    cmd.u.send.id = id;
    cmd.u.send.buffer = (char*)buffer;
    cmd.u.send.sz = sz;

    send_engine_command(ss, &cmd, 'D', sizeof(cmd.u.send));

    return s->write_buff_size;
}

void
socket_server_send_lowpriority(
        struct socket_server* ss,
        int id,
        const void* buffer,
        int sz) {

    struct socket* s = &ss->socket_map[HASH_ID(id)];
    if (s->id != id || s->type == SOCKET_TYPE_INVALID) {
        free((void*)buffer);
        return;
    }

    struct engine_command cmd;

    cmd.u.send.id = id;
    cmd.u.send.buffer = (char*)buffer;
    cmd.u.send.sz = sz;

    send_engine_command(ss, &cmd, 'P', sizeof(cmd.u.send));
}

// return -1 (ignore) when error
static int
read_socket_tcp(struct socket_server* ss, struct socket* s, struct socket_message* result) {
    char* buffer = malloc(s->read_buff_size);
    int n = (int) read(s->fd, buffer, s->read_buff_size);

    // -1 indicates error
    if (n < 0) {
        free((void*)buffer);
        switch (errno) {
            case EINTR:
                // the call was interrupted by a signal before any data was read.
                break;
            case AGAIN_WOULDBLOCK:
                // EAGAIN or EWOULDBLOCK
                // The file descriptor fd refers to a socket and has been marked nonblocking
                // (O_NONBLOCK), and the read would block. POSIX.1-2001 allows either error
                // to be returned for this case, and does not require these constants to have
                // the same value, so a portable application should check for both possibilities.
                fprintf(stderr, "SocketEngine: EAGAIN capture.\n");
                break;
            default:
                // close when error
                force_close(ss, s, result);
                return SOCKET_ERROR;
        }
        return -1;
    }

    // zero indicates socket close
    if (n == 0) {
        free((void*)buffer);
        force_close(ss, s, result);
        return SOCKET_CLOSE;
    }

    if (s->type == SOCKET_TYPE_HALFCLOSE) {
        // TODO
    }

    // Dynamic buffer size scaling
    if (n == s->read_buff_size) {
        s->read_buff_size *= 2;
    } else if (s->read_buff_size > MIN_READ_BUFFER && n * 2 < s->read_buff_size) {
        s->read_buff_size /= 2;
    }

    result->id = s->id;
    result->ud = n;
    result->data = buffer;

    return SOCKET_DATA;
}

int
socket_server_poll(struct socket_server* ss, struct socket_message* result) {
    for (;;) {

        /* all events have been processed, get new events from engine */
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
                    assert(s->type == SOCKET_TYPE_CONNECTED); // FIXME

                    if (e->read) {
                        int type;
                        type = read_socket_tcp(ss, s, result);

                        if (type == -1) {
                            break;
                        }
                        return type;
                    }
                    if (e->write) {
                        int type = send_write_buffer(ss, s, result);
                        if (type == -1) {
                            break;
                        }
                        else {
                            return type;
                        }
                    }
                }
                break;
        }

    }
}

/* ---------------------------------------------------------------------------*/
static void*
thread_network(void* ud) {
    struct socket_server* ss = (struct socket_server*)ud;
    struct socket_message result;
    int i;

    for(;;) {
        int type = socket_server_poll(ss, &result);

        switch (type) {
            case SOCKET_OPEN:
                fprintf(stdout, "SOCKET OPEN: SOCKET(%d)\n", result.id);
                break;
            case SOCKET_CLOSE:
                fprintf(stdout, "SOCKET CLOSE: SOCKET(%d)\n", result.id);
                break;
            case SOCKET_ACCEPT:
                fprintf(stdout, "SOCKET ACCEPT: NEW SOCKET(%d) FROM LISTEN SOCKET(%d)\n", result.ud, result.id);
                socket_server_start(ss, result.ud);
                break;
            case SOCKET_DATA:
                fprintf(stdout, "SOCKET DATA: FROM SOCKET(%d) SIZE(%d)\n", result.id, result.ud);
                for(i = 0; i < result.ud; ++i) {
                    if (result.data[i] == EOF) {
                        socket_server_close(ss, result.id);
                        break;
                    }
                    else {
                        fprintf(stdout, "%c", result.data[i]);
                    }
                }
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
        return 0;
    }

    pthread_t network;
    create_thread(&network, thread_network, ss);

    int id = socket_server_listen(ss, "127.0.0.1", 5000, BACKLOG);
    socket_server_start(ss, id);

    pthread_join(network, NULL);
    socket_server_release(ss);

    return 0;
}
