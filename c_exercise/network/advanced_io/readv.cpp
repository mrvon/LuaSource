#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <unistd.h>

int main()
{
    char foo[48] = { 0 };
    char bar[51] = { 0 };
    char baz[49] = { 0 };

    int fd = open("./buccaneer.txt", O_RDONLY);
    if(fd == -1)
    {
        perror("open");
        return 1;
    }

    struct iovec iov[3];

    // set up our iovec structure
    iov[0].iov_base = foo;
    iov[0].iov_len = sizeof(foo);

    iov[1].iov_base = bar;
    iov[1].iov_len = sizeof(bar);

    iov[2].iov_base = baz;
    iov[2].iov_len = sizeof(baz);

    // read into the structures with a single call
    ssize_t nr = readv(fd, iov, 3);
    if(nr == -1)
    {
        perror("readv");
        return 1;
    }

    printf("read %ld bytes\n", nr);
    printf("1 %s", foo);
    printf("2 %s", bar);
    printf("3 %s", baz);

    if(close(fd))
    {
        perror("close");
        return 1;
    }

    return 0;
}
