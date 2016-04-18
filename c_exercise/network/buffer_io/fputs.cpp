#include <stdio.h>

int main()
{
    FILE* stream = fopen("journal.txt", "a");

    if(stream == NULL)
    {
        printf("fopen failed\n");
        return -1;
    }

    if(fputs("The ship is made of wood.\n", stream) == EOF)
    {
        printf("fputs failed\n");
        return -1;
    }

    if(fclose(stream) == EOF)
    {
        printf("fclose failed\n");
        return -1;
    }

    return 0; 
}
