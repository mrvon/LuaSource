#include <unistd.h>
#include <sys/types.h>
#include <stdio.h>

int main()
{
    int ret = 0;    

    ret = truncate("./pirate.txt", 45);
    if(ret == -1)
    {
        perror("truncate");
        return -1;
    }

    return 0;
}
