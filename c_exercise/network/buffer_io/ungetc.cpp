#include <stdio.h>

int main()
{
    FILE* stream = fopen("./fgetc_2.cpp", "r");
    if(stream == NULL)
    {
        printf("fopen error\n");
        return -1;
    }

    int c = fgetc(stream);
    if(c == EOF)
    {
        printf("fgetc occurs EOF\n");
        return -1;
    }
    else
    {
        printf("c=%c\n", c);
    }

    char array[] = { 'F', 'U', 'C', 'K' };

    for(size_t i = 0; i < sizeof(array) / sizeof(char); ++i)
    {
        if(ungetc(array[i], stream) == EOF)
        {
            printf("ungetc error\n");
            return -1;
        }
    }
    
    for(size_t i = 0; i < sizeof(array) / sizeof(char); ++i)
    {
        c = fgetc(stream);
        if(c == EOF)
        {
            printf("fgetc error\n");
            return -1;
        }
        else
        {
            printf("c=%c\n", c);
        }
    }


    return 0;
}
