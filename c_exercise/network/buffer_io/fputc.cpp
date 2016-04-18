#include <stdio.h>

int main()
{
    FILE* stream = fopen("new_file.txt", "w");
    if(stream == NULL)
    {
        printf("fopen failed\n");
        return -1;
    }

    for(int i = 0; i < 10; ++i)
    {
        if(fputc('A' + i, stream) == EOF)
        {
            printf("fputc failed\n");
            return -1;
        }
    }

    if(fclose(stream) == EOF)
    {
        printf("fclose failed\n");
        return -1;
    }

    return 0;
}
