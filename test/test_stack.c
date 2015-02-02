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
	int r = 0;

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

	// -----------------------------------------------------

	lua_pop(L, 1);
	stack_dump(L);

	r = luaL_ref(L, LUA_REGISTRYINDEX);
	stack_dump(L);

	lua_rawgeti(L, LUA_REGISTRYINDEX, r);
	stack_dump(L);

	luaL_unref(L, LUA_REGISTRYINDEX, r);
	stack_dump(L);

	luaL_unref(L, LUA_REGISTRYINDEX, LUA_REFNIL);
	stack_dump(L);

	lua_rawgeti(L, LUA_REGISTRYINDEX, LUA_REFNIL);
	stack_dump(L);
	assert(luaL_ref(L, LUA_REGISTRYINDEX) == LUA_REFNIL);

	lua_settop(L, 1);
	stack_dump(L);
}

void test_reg() {
	lua_State *L = luaL_newstate();

	// variable with a unique address
	static char key = 'k';
	const char* my_str = "hello\n";
	static char key_2 = 'l';
	const char* my_str_2 = "world\n";

	// store a string
	lua_pushlightuserdata(L, (void*) &key);	// push address
	lua_pushstring(L, my_str);				// push value
	lua_settable(L, LUA_REGISTRYINDEX);		// registry[&key] = my_str

	// retrieve a string
	lua_pushlightuserdata(L, (void*)&key);	// push address
	lua_gettable(L, LUA_REGISTRYINDEX);		// retrieve value
	fprintf(stdout, lua_tostring(L, -1));	// convert to string

	// store a string 
	lua_pushstring(L, my_str_2);
	lua_rawsetp(L, LUA_REGISTRYINDEX, &key_2);

	// retrieve a string
	lua_rawgetp(L, LUA_REGISTRYINDEX, &key_2);
	fprintf(stdout, lua_tostring(L, -1));
}

static int counter(lua_State *L) {
	int val = lua_tointeger(L, lua_upvalueindex(1));
	lua_pushinteger(L, ++val);				// new value
	lua_pushvalue(L, -1);					// duplicate it
	lua_replace(L, lua_upvalueindex(1));	// update upvalue
	return 1;								// return new value
}

int new_counter(lua_State *L) {
	lua_pushinteger(L, 0);
	lua_pushcclosure(L, &counter, 1);
	return 1;
}

static int tuple(lua_State *L) {
	int count_of_argument = luaL_optint(L, 1, 0);
	if (count_of_argument == 0) {	// no argument
		int i = 0;
		// push each valid upvalue onto the stack
		for (i = 1; ! lua_isnone(L, lua_upvalueindex(i)); ++i)
			lua_pushvalue(L, lua_upvalueindex(i));
		return i - 1;	// number of values in the stack
	}
	else {	// get field 'op'
		luaL_argcheck(L, 0 < count_of_argument, 1, "index out of range");
		if (lua_isnone(L, lua_upvalueindex(count_of_argument)))
			return 0;	// no such field
		lua_pushvalue(L, lua_upvalueindex(count_of_argument));
		return 1;
	}
}

int t_tuple(lua_State *L) {
	int count_of_element = lua_gettop(L);
	lua_pushcclosure(L, &tuple, count_of_element);
	return 1;
}
