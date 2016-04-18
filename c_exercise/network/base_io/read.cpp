#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include "read_and_write.h"


int main()
{
    const int len = 100000;
    char buf[len] = { 0 };

    int fd = open("/dev/tty", O_RDONLY);
    if(fd == -1)
    {
        perror("open");
        return 1;
    }

    if(ReadBuf(fd, buf, len) == 0)
    {
        printf("Failed to read");
        return 1;
    }
    else
    {
       for(int i = 0; i < len; ++i) 
       {
           printf("%c", buf[i]);
       }
    }

    return 0;
}
