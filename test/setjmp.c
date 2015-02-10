#include <stdio.h>
#include <setjmp.h>

void do_something(jmp_buf tmp) 
{
    fprintf(stdout, "Start working\n");
    longjmp(tmp, 1);    // try to comment this line
    fprintf(stdout, "OK\n");
}

void pcall() 
{
    jmp_buf tmp;

    if(setjmp(tmp) == 0)
    {
        do_something(tmp);
    }
    fprintf(stdout, "End working\n");
}

int main()
{
    pcall();
    return 0;
}
