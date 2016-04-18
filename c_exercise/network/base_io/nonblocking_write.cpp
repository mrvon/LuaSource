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
    int fd = open("./new_file.cpp", O_WRONLY | O_CREAT, 0664);

    if(fd == -1)
    {
        perror("open");
        return -1;
    }

    const char* output_string = "hello, world - using nonblocking write";
    int lenght_of_string = strlen(output_string);

    int number_of_write = WriteBufNonblocking(fd, output_string, lenght_of_string);

    if(number_of_write != lenght_of_string)
    {
        printf("failed to write\n");
        return -1;
    }
    else
    {
        printf("all thing is write\n");
    }

    return 0;
}
