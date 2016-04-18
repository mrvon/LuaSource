#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

int main()
{
    int fd = 0;

    const char* filename_1 = "new_file_1";

    fd = creat(filename_1, 0664);
    if(fd == -1)
    {
        perror("creat");
    }

    close(fd);

    const char* filename_2 = "new_file_2";

    fd = open(filename_2, O_WRONLY | O_CREAT | O_TRUNC, 0664);
    if(fd == -1)
    {
        perror("open fashion to create new file");
    }

    close(fd);

    return 0;
}
