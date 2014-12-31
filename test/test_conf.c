#include <stdio.h>
#include <stdlib.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "error.h"

void load_conf(lua_State *L, const char *fname, int *w, int *h) {
	if (luaL_loadfile(L, fname) || lua_pcall(L, 0, 0, 0))
	{
		error(L, "cannot run config. file: %s\n", lua_tostring(L, -1));
		return;
	}

	lua_getglobal(L, "width");
	stack_dump(L);

	lua_getglobal(L, "height");
	stack_dump(L);

	if (! lua_isnumber(L, -2))
	{
		error(L, "'width' should be a number\n");
		return;
	}
	if (! lua_isnumber(L, -1))
	{
		error(L, "'height' should be a number\n");
		return;
	}

	*w = (int)lua_tointeger(L, -2);
	*h = (int)lua_tointeger(L, -1);
}

void test_conf() {
	int w = 0;
	int h = 0;
	lua_State *L = luaL_newstate();

	load_conf(L, "my_conf.txt", &w, &h);

	printf("width: %d, height: %d\n", w, h);
}