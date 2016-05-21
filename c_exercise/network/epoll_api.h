#ifndef __epool_api_h__
#define __epool_api_h__

/* epoll */
#include <netdb.h>
#include <unistd.h>
#include <sys/epoll.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <fcntl.h>

/* simplified epoll interface */

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

static void
engine_del(int epoll_fd, int socket_fd) {
    epoll_ctl(epoll_fd, EPOLL_CTL_DEL, socket_fd, NULL);
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
engine_nonblocking(int socket_fd) {
    int flag = fcntl(socket_fd, F_GETFL, 0);
    if (flag == -1) {
        return;
    }

    fcntl(socket_fd, F_SETFL, flag | O_NONBLOCK);
}

#endif
