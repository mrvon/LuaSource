#include <stdio.h>
#include <stdlib.h>

#define CommonHeader int type; int marked

typedef struct 
{
    CommonHeader;
}ObjHeader;

typedef struct
{
    CommonHeader;
    int len;
}String;

typedef union
{
    ObjHeader h;
    String s;
}Object;

int main()
{
    String* s = (String*)malloc(sizeof(String));
    if (s == NULL)
    {
        printf("Malloc Error\n");
        return 0;
    }

    s->len = 10;

    Object* o = (Object*)(s);
    o->h.type = 1000;
    o->h.marked = 1024;

    printf("LEN: %d TYPE: %d, MARK: %d\n", s->len, s->type, s->marked);

    return 0;
}
