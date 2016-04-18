#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>


int main()
{
    int fd = open("./pirate.txt", O_WRONLY);
    if(fd == -1)
    {
        perror("open");
        return -1;
    }

    int ret = ftruncate(fd, 45);
    if(ret == -1)
    {
        perror("ftruncate");
        return -1;
    }

    return 0;
}
