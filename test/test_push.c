#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

void test_push() {
	lua_State *L = luaL_newstate();

	//lua_pushnil(L);
	//lua_pushnumber(L, 1024);
	lua_pushstring(L, "Hello world");
	lua_pushstring(L, "C program");
	lua_pushinteger(L, 999);

	fprintf(stdout, "Stack top(-1): %d , is string: %d , type: %s\n", (int)lua_tointeger(L, -1), lua_isstring(L, -1), lua_typename(L, lua_type(L, -1)));
	fprintf(stdout, "Stack -2: %s , is string: %d , type: %s\n", lua_tostring(L, -2), lua_isstring(L, -2), lua_typename(L, lua_type(L, -2)));
	fprintf(stdout, "Stack base(1): %s , is number: %d , type: %s\n", lua_tostring(L, 1), lua_isnumber(L, 1), lua_typename(L, lua_type(L, 1)));

	{
		size_t length = 0;
		const char* str = lua_tolstring(L, 1, &length);
		int bv = lua_toboolean(L, 1);
		fprintf(stdout, "%s , length: %d, bool: %d\n", str, (int)length, bv);
	}

	{
		int is_num = 0;
		fprintf(stdout, "Stack base(1): %s: %d\n", lua_tostring(L, 1), (int)lua_tointegerx(L, 1, &is_num));
		fprintf(stdout, "Is number: %d\n", is_num);
	}

	{
		size_t length = 0;
		const char* str = lua_tolstring(L, -1, &length);
		assert(str[length] == '\0');
		assert(strlen(str) <= length);
	}
}
