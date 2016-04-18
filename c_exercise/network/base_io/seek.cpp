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
    int fd = open("./seek.cpp", O_RDONLY);

    if(fd == -1)
    {
        perror("open");
        return -1;
    }

    int end_pos = lseek(fd, 0, SEEK_END);
    if(end_pos == -1)
    {
        perror("seek to end");
        return -1;
    }

    int len = end_pos;

    if(lseek(fd, 0, SEEK_SET) == -1)
    {
        perror("seek to beg");
        return -1;
    }

    char* buf = new char[len];

    int real_read_len = ReadBuf(fd, buf, len);
    if(real_read_len == len)
    {
        for(int i = 0; i < len; ++i)
        {
            printf("%c", buf[i]);
        }
    }
    else
    {
       printf("%d\n", real_read_len);
    }

    return 0; 
}
