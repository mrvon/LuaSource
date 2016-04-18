#include <stdio.h>
#include <stdlib.h>
#include <sys/epoll.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "../base_io/read_and_write.h"


#define MAX_EVENTS      64
#define BUF_LEN         1024

int main()
{
    int epfd = epoll_create1(0);
    if(epfd < 0)
    {
        perror("epoll_create1");
        return 1;
    }

    int tty_fd  = open("/dev/tty", O_RDONLY);
    if(tty_fd == -1)     
    {
        perror("open");
        return 1;
    }

    struct epoll_event event;
    event.data.fd = tty_fd;
    event.events = EPOLLIN;

    int ret = epoll_ctl(epfd, EPOLL_CTL_ADD, tty_fd, &event);
    if(ret == -1)
    {
        perror("epoll_ctl");
        return 1;
    }

    struct epoll_event* events = (struct epoll_event*)malloc(sizeof(struct epoll_event) * MAX_EVENTS);
    if(events == NULL)
    {
        perror("malloc");
        return 1;
    }

    while(true)
    {
        int nr_events = epoll_wait(epfd, events, MAX_EVENTS, -1);
        if(nr_events < 0)
        {
            perror("epoll_wait");
            free(events);
            return 1;
        }

        char read_buf[BUF_LEN];

        for(int i = 0; i < nr_events; ++i)
        {
            printf("event=%u on fd=%d\n", events[i].events, events[i].data.fd);

            // We now can, per events[i].events, operate on
            // events[i].data.fd without blocking

            if(events[i].events & EPOLLIN) 
            {
                int num_of_read = read(events[i].data.fd, read_buf, BUF_LEN);
                if(num_of_read > 0)
                {
                    printf("read %d byte\n", num_of_read);
                    WriteBuf(STDOUT_FILENO, read_buf, num_of_read);
                }
            }
        }
    }
}
