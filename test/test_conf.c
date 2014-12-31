#include <stdio.h>
#include <stdlib.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "test_func.h"

#define MAX_COLOR	255

struct ColorTable {
	char* name;
	unsigned char red;
	unsigned char green;
	unsigned char blue;
}colortable[] = {
	{"WHITE",	MAX_COLOR,	MAX_COLOR,	MAX_COLOR},
	{"RED",		MAX_COLOR,	0,					0},
	{"GREEN",	0,			MAX_COLOR,			0},
	{"BLUE",	0,			0,			MAX_COLOR},
	{NULL,		0,			0,					0},	// sentinel
};

// Assume that table is one the stack top
int getcolorfield(lua_State *L, const char *key) {
	int result = 0;

	//lua_pushstring(L, key);		// push key
	//lua_gettable(L, -2);		// get background[key]
	lua_getfield(L, -1, key);
	
	if (! lua_isnumber(L, -1)) {
		error(L, "invalid component in background color");
		return 0;
	}
	result = (int)(lua_tonumber(L, -1) * MAX_COLOR);
	lua_pop(L, 1); // remove number
	return result;
}

// Assume that table is at the top
void setcolorfield(lua_State *L, const char* index, int value) {
	lua_pushstring(L, index);	// key
	lua_pushnumber(L, (double)value / MAX_COLOR); // value
	lua_settable(L, -3);
}

void load_conf(lua_State *L, const char *fname, int *w, int *h, int *r, int *g, int *b) {
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

	lua_getglobal(L, "background");
	if (! lua_istable(L, -1)) {
		error(L, "'background' is not a table");
		return;
	}

	*r = getcolorfield(L, "r");
	*g = getcolorfield(L, "g");
	*b = getcolorfield(L, "b");
}

void test_conf() {
	int w = 0;
	int h = 0;
	int r = 0;
	int g = 0;
	int b = 0;
	lua_State *L = luaL_newstate();
	luaL_openlibs(L);

	load_conf(L, "my_conf.txt", &w, &h, &r, &g, &b);

	printf("width: %d, height: %d\n", w, h);
	printf("red: %d, green: %d, blue: %d\n", r, g, b);
}