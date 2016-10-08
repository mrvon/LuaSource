#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <setjmp.h>

#define LUAI_THROW(L, c)		longjmp((c)->b, 1)
#define LUAI_TRY(L, c, a)		if (setjmp((c)->b) == 0) { a }
#define luai_jmpbuf		    jmp_buf

#define LUA_OK 1

typedef struct lua_longjmp {
	struct lua_longjmp *previous;
	luai_jmpbuf b;
	volatile int status;  /* error code */
} lua_longjmp;

typedef struct lua_State {
    lua_longjmp* error_jump;
} lua_State;

typedef void (*Pfunc) (lua_State *L, void *ud);

void print_tab(void* ud)
{
    if (ud == NULL)
        return;
    int i = (*(int*)ud);
    while (i--) {
        fprintf(stdout, "\t");
    }
}

void hello_world(lua_State* L, void* ud)
{
    print_tab(ud);
    fprintf(stdout, "Enter function(%s)\n", __func__);

    print_tab(ud);
    fprintf(stdout, "Hello world\n");
    LUAI_THROW(L, L->error_jump);    // try to comment this line

    print_tab(ud);
    fprintf(stdout, "Leave function(%s)\n", __func__);
}

int pcall(lua_State* L, Pfunc f, void* ud)
{
	struct lua_longjmp lj;
	lj.status = LUA_OK;
	lj.previous = L->error_jump;  /* chain new error handler */
	L->error_jump = &lj;

    print_tab(ud);
    fprintf(stdout, "Start protected call\n");

	LUAI_TRY(L, &lj,
        (*f)(L, ud);
	);

    print_tab(ud);
    fprintf(stdout, "End protected call\n");

	L->error_jump = lj.previous;  /* restore old error handler */
	return lj.status;
}

void real_call(lua_State* L, void* ud)
{
    print_tab(ud);
    fprintf(stdout, "Enter function(%s)\n", __func__);

    int i = (*(int*)ud) + 1;
    pcall(L, hello_world, &i);

    /* LUAI_THROW(L, L->error_jump);    // try to comment this line */

    print_tab(ud);
    fprintf(stdout, "Leave function(%s)\n", __func__);
}

int main(int argc, char const* argv[])
{
    lua_State* L = (lua_State*) malloc(sizeof(lua_State));
    L->error_jump = NULL;
    assert(L);

    int i = 1;
    pcall(L, real_call, &i);

    return 0;
}
