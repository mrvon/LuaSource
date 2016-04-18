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
    int fd = open("./read_all_byte.cpp", O_RDONLY);
    if(fd == -1)
    {
        perror("open");
        return -1;
    }

    const int buf_len = 10;
    char buf[buf_len] = { 0 };
    int real_read_len = 0;

    while((real_read_len = ReadBuf(fd, buf, buf_len)) != 0)
    {
        for(int i = 0; i < real_read_len; ++i)
        {
            printf("%c", buf[i]);
        }
    }

    return 0;
}
