#include <stdio.h>
#include <limits.h>

int main()
{
    FILE* stream = fopen("./Makefile", "r");
    if(stream == NULL)
    {
        printf("fopen failed\n");
        return -1;
    }

    char buf[LINE_MAX] = { 0 };

    while(fgets(buf, LINE_MAX, stream) != NULL)
    {
        printf("%s", buf);
    }

    return 0;
}
