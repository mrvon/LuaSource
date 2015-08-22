#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "test.h"

static void error_dump(lua_State* L, const char* fmt, ...) {
	va_list argp;
	va_start(argp, fmt);
	vfprintf(stderr, fmt, argp);
	va_end(argp);
}

static int open_global_table(lua_State *L, const char* table_name)
{
    lua_getglobal(L, table_name);
    if (! lua_istable(L, -1)) {
        lua_pop(L, 1);
        return -1;
    }

    return 0;
}

static int open_field_table(lua_State *L, const char* table_name)
{
    lua_pushstring(L, table_name);
    lua_gettable(L, -2);

    if (! lua_istable(L, -1)) {
        lua_pop(L, 1);
        return -1;
    }

    return 0;
}

static int close_table(lua_State *L)
{
    if (! lua_istable(L, -1)) {
        return -1;
    }
    lua_settop(L, -2);
    return 0;
}

static int getfieid_int(lua_State *L, const char* field_name)
{
    int result = 0;

    lua_pushstring(L, field_name);
    lua_gettable(L, -2);

    if (! lua_isnumber(L, -1)) {
        lua_pop(L, 1);
        return 0;
    }

    result = (int)lua_tonumber(L, -1);
    lua_pop(L, 1);

    return result;
}

static int before_call(lua_State* L)
{
    return lua_gettop(L);
}

static void after_call(lua_State* L, int top)
{
    lua_settop(L, top);
}

static void new_call_va(lua_State* L, const char* func, const char* sig, ...) {
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
			error_dump(L, "invalid option (%c)\n", *(sig - 1));
            return;
		}
	}
	endargs:

	nres = (int)strlen(sig);	// number of expected results

	if (lua_pcall(L, narg, nres, 0) != 0) {
		error_dump(L, "error calling '%s': %s\n", func, lua_tostring(L, -1));
        return;
	}

	nres = -nres; // stack index of first result
	while(*sig) {
		switch(*sig++) {
		case 'b': // boolean result
			{
				int b = 0;
				if (! lua_isboolean(L, nres)) {
					error_dump(L, "wrong result type\n");
                    return;
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
					error_dump(L, "wrong result type\n");
                    return;
				}
				*va_arg(vl, double*) = n;
				break;
			}
		case 'i': // int result
			{
				int is_num = 0;
				int n = (int)lua_tointegerx(L, nres, &is_num);
				if (! is_num) {
					error_dump(L, "wrong result type\n");
                    return;
				}
				*va_arg(vl, int*) = n;
				break;
			}
		case 's': // string result
			{
				const char* s = lua_tostring(L, nres);
				if (s == NULL) {
					error_dump(L, "wrong result type\n");
                    return;
				}
				*va_arg(vl, const char**) = s;
				break;
			}
		default:
			{
				error_dump(L, "invalid option (%c)\n", *(sig - 1));
                return;
			}
		}
		++nres;
	}

	va_end(vl);
}


void test_newconf()
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    const char* conf_filename = "newconf.lua";
    if (luaL_loadfile(L, conf_filename) || lua_pcall(L, 0, 0, 0)) {
		error_dump(L, "cannot run config. file: %s\n", lua_tostring(L, -1));
		return;
    }

    int x = 10;
    int y = 20;
    int z = 0;
    const char* str = NULL;
    stack_dump(L);
    int top = before_call(L);
    new_call_va(L, "test_func", "ii>is", x, y, &z, &str);
    after_call(L, top);
    printf("X = %d Y = %d Z = %d N = %s\n", x, y, z, str);
    stack_dump(L);

    if(open_global_table(L, "Game") == 0) {
        if (open_field_table(L, "World") == 0) {
            int king = getfieid_int(L, "King");
            printf("Value of (Game.World.king) is %d\n", king);
            close_table(L);
        }
        close_table(L);
    }

    lua_close(L);
}
