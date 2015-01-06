#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

void stack_dump(lua_State *L) {
	int i;
	int top = lua_gettop(L);
	fprintf(stdout, "-------------------STACK DUMP-------------------\n");
	fprintf(stdout, "StkIdx\t\tType\t\tValue\n");
	fprintf(stdout, "												 \n");
	for (i = top; i >= 1; --i) {
		int t = lua_type(L, i);
		fprintf(stdout, "%d\t\t%s\t\t", i, lua_typename(L, t));

		switch(t) {
		case LUA_TSTRING:
			fprintf(stdout, "'%s'", lua_tostring(L, i));
			break;
		case LUA_TBOOLEAN:
			fprintf(stdout, lua_toboolean(L, i) ? "true" : "false");
			break;
		case LUA_TNUMBER:
			fprintf(stdout, "%g", lua_tonumber(L, i));
			break;
		default:
			printf("%s", lua_typename(L, t));
			break;
		}
		fprintf(stdout, "\n");		// put a separator
	}
	fprintf(stdout, "------------------------------------------------\n");
}

void test_stack() {
	lua_State *L = luaL_newstate();

	lua_pushstring(L, "World");
	lua_pushstring(L, "Hello");
	lua_pushnumber(L, 3.14);
	lua_pushinteger(L, 1024);
	lua_pushboolean(L, 1);
	lua_pushboolean(L, 0);
	lua_pushnil(L);
	stack_dump(L);

	lua_settop(L, -1);
	lua_insert(L, -1);
	lua_copy(L, -1, -1);
	stack_dump(L);

	fprintf(stdout, "STACK index 1: %s\n", lua_tostring(L, 1));
	fprintf(stdout, "STACK index 2: %s\n", lua_tostring(L, 2));
	fprintf(stdout, "STACK top index: %d\n", lua_gettop(L));

	lua_pushvalue(L, -1);
	stack_dump(L);

	lua_remove(L, 1);
	stack_dump(L);

	lua_insert(L, 1);
	stack_dump(L);

	lua_replace(L, 2);
	stack_dump(L);

	lua_copy(L, -1, -2);
	stack_dump(L);

	lua_pop(L, 1);
	stack_dump(L);

	lua_settop(L, 1);
	stack_dump(L);
}