#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "test.h"

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
int __getcolorfield(lua_State *L, const char *key) {
	int result = 0;

	lua_pushstring(L, key);		// push key
	lua_gettable(L, -2);		// get background[key]
	
	if (! lua_isnumber(L, -1)) {
		error(L, "invalid component in background color");
		return 0;
	}
	result = (int)(lua_tonumber(L, -1) * MAX_COLOR);
	lua_pop(L, 1); // remove number
	return result;
}

// Assume that table is one the stack top
int getcolorfield(lua_State *L, const char *key) {
    int result = 0;

    lua_getfield(L, -1, key);   // get background[key]

    if (! lua_isnumber(L, -1)) {
        error(L, "invalid component in background color");
        return 0;
    }

    result = (int)(lua_tonumber(L, -1) * MAX_COLOR);
    lua_pop(L, 1); // remove number
    return result;
}

// Assume that table is at the top
void __setcolorfield(lua_State *L, const char* index, int value) {
	lua_pushstring(L, index);	// key
	lua_pushnumber(L, (double)value / MAX_COLOR); // value
	lua_settable(L, -3);
}

// Assume that table is at the top
void setcolorfield(lua_State *L, const char* index, int value) {
	lua_pushnumber(L, (double)value / MAX_COLOR); // values
	lua_setfield(L, -2, index);
}

void setcolor(lua_State* L, struct ColorTable* ct) {
	lua_newtable(L);
	setcolorfield(L, "r", ct->red);
	setcolorfield(L, "g", ct->green);
	setcolorfield(L, "b", ct->blue);
	lua_setglobal(L, ct->name);
}

void setcolortolua(lua_State* L)
{
	int i = 0;	// search the color table
	for (i = 0; colortable[i].name != NULL; ++i) {
		setcolor(L, &colortable[i]);
	}
}

// Call a function 'f' defined in Lua
double call_f(lua_State* L, double x, double y) {
	int is_num = 0;
	double z = 0;

	// push functions and arguments
	lua_getglobal(L, "f");	// function to be called
	lua_pushnumber(L, x);	// push 1st argument
	lua_pushnumber(L, y);	// push 2nd argument

	// do the call (2 arguments, 1 result)
	if (lua_pcall(L, 2, 1, 0) != LUA_OK) {
		error(L, "error running function 'f': %s\n", lua_tostring(L, -1));
		return 0;
	}

	// retrieve result
	z = lua_tonumberx(L, -1, &is_num);
	if (! is_num) {
		error(L, "function 'f' must return a number\n");
		return 0;
	}
	lua_pop(L, 1);	// pop returned value

	return z;
}

// Generic call function
void call_va(lua_State* L, const char* func, const char* sig, ...) {
	va_list vl;
	int narg = 0;
	int nres = 0;	// number of arguments and results

	va_start(vl, sig);
	lua_getglobal(L, func); // push function

	for (narg = 0; *sig; ++narg) {
		// check stack space
		luaL_checkstack(L, 1, "too many arguments");

		switch(*sig++) {
		case 'b': // boolean argument
			lua_pushboolean(L, va_arg(vl, int));
			break;
		case 'd': // double argument
			lua_pushnumber(L, va_arg(vl, double));
			break;
		case 'i': // int argument	
			lua_pushinteger(L, va_arg(vl, int));
			break;
		case 's': // string argument
			lua_pushstring(L, va_arg(vl, char*));
			break;
		case '>': // end of argument
			goto endargs;
		default:
			error(L, "invalid option (%c)\n", *(sig - 1));
		}
	}
	endargs:

	nres = (int)strlen(sig);	// number of expected results

	if (lua_pcall(L, narg, nres, 0) != 0) {
		error(L, "error calling '%s': %s\n", func, lua_tostring(L, -1));
		return;
	}

	nres = -nres; // stack index of first result
	while(*sig) {
		switch(*sig++) {
		case 'b': // boolean result
			{
				int b = 0;
				if (! lua_isboolean(L, nres)) {
					error(L, "wrong result type\n");
				}
				b = lua_toboolean(L, nres);
				*va_arg(vl, int*) = b;
			}
			break;
		case 'd': // double result
			{
				int is_num = 0;
				double n = lua_tonumberx(L, nres, &is_num);
				if (! is_num) {
					error(L, "wrong result type\n");
				}
				*va_arg(vl, double*) = n;
				break;
			}
		case 'i': // int result
			{
				int is_num = 0;
				int n = (int)lua_tointegerx(L, nres, &is_num);
				if (! is_num) {
					error(L, "wrong result type\n");
				}
				*va_arg(vl, int*) = n;
				break;
			}
		case 's': // string result
			{
				const char* s = lua_tostring(L, nres);
				if (s == NULL) {
					error(L, "wrong result type\n");
				}
				*va_arg(vl, const char**) = s;
				break;
			}
		default:
			{
				error(L, "invalid option (%c)\n", *(sig - 1));
				break;
			}
		}
		++nres;
	}

	va_end(vl);
}

void load_conf(lua_State *L, const char *fname) {
	int w = 0;
	int h = 0;

	int r = 0;
	int g = 0;
	int b = 0;

	double x = 0;
	double y = 0;
	double z = 0;

	const char* h_str = "hello";
	const char* w_str = " world";
	const char* str = "";

	int is_less = 0;

	// Export global value
	setcolortolua(L);

	if (luaL_loadfile(L, fname) || lua_pcall(L, 0, 0, 0))
	{
		error(L, "cannot run config. file: %s\n", lua_tostring(L, -1));
		return;
	}

	lua_getglobal(L, "width");
	lua_getglobal(L, "height");

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

	w = (int)lua_tointeger(L, -2);
	h = (int)lua_tointeger(L, -1);

	// clear stack
	lua_pop(L, 2);

	printf("width: %d, height: %d\n", w, h);

	lua_getglobal(L, "background");
	if (lua_isstring(L, -1)) {
		const char* colorname = lua_tostring(L, -1); // get string
		int i = 0;	// search the color table
		for (i = 0; colortable[i].name != NULL; ++i) {
			if(strcmp(colorname, colortable[i].name) == 0) {
				break;
			}
		}

		if (colortable[i].name == NULL) {
			error(L, "invalid color name (%s)\n", colorname);
			return;
		}
		else {
			r = colortable[i].red;
			g = colortable[i].green;
			b = colortable[i].blue;
		}
	}
	else if (lua_istable(L, -1)) {
		r = getcolorfield(L, "r");
		g = getcolorfield(L, "g");
		b = getcolorfield(L, "b");
	}
	else {
		error(L, "'background' is not a table or a string\n");
		return;
	}
	// clear stack
	lua_pop(L, 1);
	printf("red: %d, green: %d, blue: %d\n", r, g, b);

	x = 1.5;
	y = 2.9;
	z = call_f(L, x, y);
	printf("f(%g, %g) -> %g\n", x, y, z);

	x = -1.024;
	y = 0.618;
	call_va(L, "f", "dd>d", x, y, &z);
	lua_pop(L, 1);
	printf("f(%g, %g) -> %g\n", x, y, z);

	call_va(L, "sf", "ss>s", h_str, w_str, &str);
	printf("sf('%s', '%s') -> '%s'\n", h_str, w_str, str);
	//After pop string, pointer str is undefine
	lua_pop(L, 1);

	call_va(L, "less_than", "dd>b", x, y, &is_less);
	lua_pop(L, 1);
	printf("less_than(%g, %g) -> %d\n", x, y, is_less);

	call_va(L, "less_than", "dd>b", y, x, &is_less);
	lua_pop(L, 1);
	printf("less_than(%g, %g) -> %d\n", y, x, is_less);
}

void test_conf() {
	lua_State *L = luaL_newstate();
	luaL_openlibs(L);

	load_conf(L, "my_conf.txt");
}
