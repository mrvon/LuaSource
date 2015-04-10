#include <stdio.h>
#include <setjmp.h>

#define LUAI_THROW(c)		longjmp(c, 1)
#define LUAI_TRY(c, a)		if (setjmp(c) == 0) { a }
#define luai_jmpbuf		    jmp_buf

void do_something(luai_jmpbuf lj)
{
    fprintf(stdout, "Start working\n");
    LUAI_THROW(lj);    // try to comment this line
    fprintf(stdout, "OK\n");
}

void pcall() 
{
    luai_jmpbuf lj;

	LUAI_TRY(lj,
        do_something(lj);
	);

    fprintf(stdout, "End working\n");
}

int main()
{
    pcall();
    return 0;
}
