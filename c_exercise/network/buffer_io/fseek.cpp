#include <stdio.h>
#include <assert.h>


int main()
{
    FILE* stream = fopen("./fseek.cpp", "r");

    if(stream == NULL)
    {
        perror("fopen");
        return -1;
    }

    if(fseek(stream, 0, SEEK_END) == -1)
    {
        perror("fseek");
        return -1;
    }

    long len_of_file = ftell(stream);
    if(len_of_file == -1)
    {
        perror("ftell");
        return -1;
    }

    if(fseek(stream, 0, SEEK_SET) == -1)
    {
        perror("fseek");
        return -1;
    }
    
    printf("%ld\n", len_of_file);

    char* buf = new char[len_of_file];
    assert(buf);

    if(fgets(buf, len_of_file, stream) == NULL)
    {
        perror("fgets");
        return -1;
    }

    // Only print first line of the file,
    // because fgets reading stops after an EOF 
    // or a newline character is reached.
    printf("%s", buf);

    return 0;
}
