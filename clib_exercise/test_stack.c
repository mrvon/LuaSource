#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

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

void test_reg() {
	lua_State *L = luaL_newstate();
    
	// variable with a unique address
	static char key = 'k';
	const char* my_str = "hello\n";
	static char key_2 = 'l';
	const char* my_str_2 = "world\n";
    static char key_3 = 'm';
    const char* my_str_3 = "foo\n";

	int r = 0;

	lua_pushstring(L, "Hello world");

    // pop the top value, create new reference
	r = luaL_ref(L, LUA_REGISTRYINDEX);

    // get value by reference
	lua_rawgeti(L, LUA_REGISTRYINDEX, r);

    // release reference
	luaL_unref(L, LUA_REGISTRYINDEX, r);

    // release nil reference is not effect
	luaL_unref(L, LUA_REGISTRYINDEX, LUA_REFNIL);

    // get nil value by LUA_REFNIL
	lua_rawgeti(L, LUA_REGISTRYINDEX, LUA_REFNIL);
	stack_dump(L);

	assert(luaL_ref(L, LUA_REGISTRYINDEX) == LUA_REFNIL);

	// store a string
	lua_pushlightuserdata(L, (void*)&key);	// push address
	lua_pushstring(L, my_str);				// push value
	lua_settable(L, LUA_REGISTRYINDEX);		// registry[&key] = my_str

	// retrieve a string
	lua_pushlightuserdata(L, (void*)&key);	// push address
	lua_gettable(L, LUA_REGISTRYINDEX);		// retrieve value
	fprintf(stdout, "%s", lua_tostring(L, -1));	// convert to string

	// store a string 
	lua_pushstring(L, my_str_2);
	lua_rawsetp(L, LUA_REGISTRYINDEX, &key_2);

	// retrieve a string
	lua_rawgetp(L, LUA_REGISTRYINDEX, &key_2);
	fprintf(stdout, "%s", lua_tostring(L, -1));

    // store a string
    lua_pushlightuserdata(L, (void*)&key_3); // push address
    lua_pushstring(L, my_str_3);             // push value
    lua_rawset(L, LUA_REGISTRYINDEX);        // registry[&key] = my_str_3

    // retrieve a string
    lua_pushlightuserdata(L, (void*)&key_3); // push address
    lua_rawget(L, LUA_REGISTRYINDEX);        // retrieve value
    fprintf(stdout, "%s", lua_tostring(L, -1));    // convert to string
}

