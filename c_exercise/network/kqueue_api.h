#ifndef __kqueue_api_h__
#define __kqueue_api_h__

/* kqueue */

#include <netdb.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/event.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

/* simplified kqueue interface */

struct event {
	void* s;        /* application socket */
	bool read;      /* can read flag */
	bool write;     /* can write flag */
};

static bool
engine_invalid(int kqueue_fd) {
    return kqueue_fd == -1;
}

static int
engine_create() {
    return kqueue();
}

static void
engine_release(int kqueue_fd) {
    close(kqueue_fd);
}

static void
engine_del(int kqueue_fd, int socket_fd) {
    struct kevent ke;
    EV_SET(&ke, socket_fd, EVFILT_READ, EV_DELETE, 0, 0, NULL);
    kevent(kqueue_fd, &ke, 1, NULL, 0, NULL);
    EV_SET(&ke, socket_fd, EVFILT_WRITE, EV_DELETE, 0, 0, NULL);
    kevent(kqueue_fd, &ke, 1, NULL, 0, NULL);
}

static int
engine_add(int kqueue_fd, int socket_fd, void* ud) {
    struct kevent ke;
    EV_SET(&ke, socket_fd, EVFILT_READ, EV_ADD, 0, 0, ud);
    if (kevent(kqueue_fd, &ke, 1, NULL, 0, NULL) == -1) {
        return 1;
    }
    EV_SET(&ke, socket_fd, EVFILT_WRITE, EV_ADD, 0, 0, ud);
    if (kevent(kqueue_fd, &ke, 1, NULL, 0, NULL) == -1) {
        EV_SET(&ke, socket_fd, EVFILT_READ, EV_DELETE, 0, 0, NULL);
        kevent(kqueue_fd, &ke, 1, NULL, 0, NULL);
        return 1;
    }
    EV_SET(&ke, socket_fd, EVFILT_WRITE, EV_DISABLE, 0, 0, ud);
    if (kevent(kqueue_fd, &ke, 1, NULL, 0, NULL) == -1) {
        engine_del(kqueue_fd, socket_fd);
        return 1;
    }
    return 0;
}

static void
engine_write(int kqueue_fd, int socket_fd, void* ud, bool enable) {
    struct kevent ke;
    EV_SET(&ke, socket_fd, EVFILT_WRITE, enable ? EV_ENABLE : EV_DISABLE, 0, 0, ud);
    if (kevent(kqueue_fd, &ke, 1, NULL, 0, NULL) == -1) {
        // todo: check error
    }
}

static int
engine_wait(int kqueue_fd, struct event* e, int max) {
    struct kevent ev[max];
    int n = kevent(kqueue_fd, NULL, 0, ev, max, NULL);
    int i;
    for (i = 0; i < n; ++i) {
        e[i].s = ev[i].udata;
        unsigned filter = ev[i].filter;
        e[i].read = (filter == EVFILT_READ);
        e[i].write = (filter == EVFILT_WRITE);
    }

    return n;
}

static void
engine_nonblocking(socket_fd) {
    int flag = fcntl(socket_fd, F_GETFL, 0);
    if (flag == -1) {
        return;
    }

    fcntl(socket_fd, F_SETFL, flag | O_NONBLOCK);
}

#endif
