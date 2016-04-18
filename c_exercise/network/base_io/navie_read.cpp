#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

int main()
{
    unsigned long word      = 0;
    ssize_t number_of_read  = 0;
    int fd                  = 0;

    fd = open("./read.cpp", O_RDONLY);
    if(fd == -1)
    {
        perror("open");
        return 1;
    }

    number_of_read = read(fd, &word, sizeof(word));

    if(number_of_read == -1)
    {
        perror("read");
        return 1;
    }
    else
    {
        printf("%ld", word);
    }
    
    return 0;
}
