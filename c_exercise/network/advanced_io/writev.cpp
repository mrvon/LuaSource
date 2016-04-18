#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <sys/uio.h>
#include <unistd.h>

int main()
{

    char* buf[] = {
            "The term buccaneer comes from the word boucan.\n",
            "A boucan is a wooden frame used for cooking meat.\n",
            "Buccaneer is the West Indies name for a pirate.\n",
    };

    printf("First sentence lenght: %ld\n", strlen(buf[0]));
    printf("Second sentence lenght: %ld\n", strlen(buf[1]));
    printf("Third sentence lenght: %ld\n", strlen(buf[2]));

    int fd = open("buccaneer.txt", O_WRONLY | O_CREAT | O_TRUNC, 0664);
    if(fd == -1)
    {
        perror("open");
        return 1;
    }

    // fill out three iovec structures
    struct iovec iov[3];
    for(int i = 0; i < 3; ++i)
    {
        iov[i].iov_base = buf[i];
        iov[i].iov_len = strlen(buf[i]) + 1;
    }

    // with a single call, write them all out
    ssize_t nr = writev(fd, iov, 3);
    if(nr == -1)
    {
        perror("writev");
        return 1;
    }
    printf("wrote %ld bytes\n", nr);

    if(close(fd))
    {
        perror("close");
        return 1;
    }

    return 0;
}
