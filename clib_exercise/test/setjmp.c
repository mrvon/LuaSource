#include <stdio.h>
#include <setjmp.h>

#define LUAI_THROW(c)		longjmp(c, 1)
#define LUAI_TRY(c, a)		if (setjmp(c) == 0) { a }
#define luai_jmpbuf		    jmp_buf

void real_call(luai_jmpbuf lj)
{
    LUAI_THROW(lj);    // try to comment this line

    fprintf(stdout, "OK\n");
}

void pcall()
{
    luai_jmpbuf lj;

    fprintf(stdout, "Start protected call\n");

	LUAI_TRY(lj,
        real_call(lj);
	);

    fprintf(stdout, "End protected call\n");
}

int main()
{
    pcall();
    return 0;
}
