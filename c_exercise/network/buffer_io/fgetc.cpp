#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>


int main()
{
    int fd = open("./fgetc.cpp", O_RDONLY);
    if(fd == -1)
    {
        perror("open");
        return -1;
    }

    FILE* stream = NULL;

    stream = fdopen(fd, "r");
    if(stream == NULL)
    {
        printf("fdopen error\n");
        return -1;
    }

    int c = fgetc(stream);
    if(c == EOF)
    {
        printf("EOF\n");
        return -1;
    }
    else
    {
        printf("c=%c\n", (char)c);
    }

    return 0;
}
