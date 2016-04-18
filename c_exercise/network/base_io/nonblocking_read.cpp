#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include "read_and_write.h"

int main()
{
    int fd = open("/dev/tty", O_RDONLY | O_NONBLOCK);
    
    if(fd == -1)
    {
        perror("open");
        return -1;
    }

    const int len = 10;
    char buf[len] = { 0 };

    int number_of_read = ReadBufNonblocking(fd, buf, len);
    if(number_of_read == -1)
    {
        printf("read failed\n");
    }
    else if(number_of_read == 0)
    {
        printf("nothing to read\n");
    }
    else
    {
        printf("Have read %d char\n", number_of_read);
        for(int i = 0; i < number_of_read; ++i)
        {
            printf("%c", buf[i]);
        }
    }

    return 0;
}
