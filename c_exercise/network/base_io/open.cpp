#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main()
{
    int fd = 0;

    fd = open("./Makefile", O_WRONLY | O_TRUNC);

    if(fd == -1) 
    {
        // error
    }
    else
    {
        //
    }

    return 0;
}


