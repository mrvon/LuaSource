#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "test.h"

int l_sin(lua_State* L) {
	double d = luaL_checknumber(L, 1);	// get argument
	lua_pushnumber(L, sin(d));			// push result
	return 1;							// number of results
}

int summation(lua_State* L) {
	int num_of_argument = lua_gettop(L);
	int i = 0;
	double sum = 0;
	for (i = 1; i <= num_of_argument; ++i) {
		sum += luaL_checknumber(L, i);
	}
	lua_pushnumber(L, sum);
	return 1;
}

int my_pack(lua_State* L) {
	int i = 0;
	int num_of_element = lua_gettop(L);
	lua_newtable(L);
	for (i = 1; i <= num_of_element; ++i) {
		lua_pushnumber(L, i);					// key
		lua_pushvalue(L, 1);					// push value
		lua_remove(L, 1);						// remove value

		lua_settable(L, -3);
	}

	return 1;
}

int my_reverse(lua_State* L) {
	int num_of_element = lua_gettop(L);
	int i = 0;

	for (i = 1; i <= num_of_element; ++i) {
		lua_insert(L, i);
	}

	return num_of_element;
}

int my_foreach(lua_State* L) {
	luaL_checktype(L, 1, LUA_TTABLE);
	luaL_checktype(L, 2, LUA_TFUNCTION);

	lua_pushnil(L);	// first key
	while(lua_next(L, 1) != 0) {
		// 'key' (at index -2) and 'value' (at index - 1)
		lua_pushvalue(L, -2);   // copy key
        lua_pushvalue(L, 2);	// copy f
		lua_insert(L, -3);
        lua_insert(L, -2);

		// do the call (2 arguments, 0 result)
		if (lua_pcall(L, 2, 0, 0) != LUA_OK) {
			error(L, "error running function 'f': %s\n", lua_tostring(L, -1));
			return 0;
		}
	}
	lua_pop(L, 0);

	return 0;
}

int l_map(lua_State* L) {
	int i = 0;
	int n = 0;

	// 1st argument must be a table(t)
	luaL_checktype(L, 1, LUA_TTABLE);

	// 2nd argument must be a function(f)
	luaL_checktype(L, 2, LUA_TFUNCTION);

	n = luaL_len(L, 1); // get size of table

	for(i = 1; i <= n; ++i) {
		lua_pushvalue(L, 2);	// push f
		lua_rawgeti(L, 1, i);	// push t[i]
		lua_call(L, 1, 1);		// call f(t[i])
		lua_rawseti(L, 1, i);	// t[i] = result
	}

	return 0;	// no results
}

int l_filter(lua_State *L) {
	int n = 0;
	int r = 0;
	int b = 0;
	int i = 0;

	// 1st argument must be a table(t)
	luaL_checktype(L, 1, LUA_TTABLE);

	// 2nd argument must be a function(f)
	luaL_checktype(L, 2, LUA_TFUNCTION);

	// result table
	lua_newtable(L);

	n = luaL_len(L, 1); // get size of table

	for (i = 1; i <= n; ++i) {
		lua_pushvalue(L, 2);		// push f
		lua_rawgeti(L, 1, i);		// push t[i]
		lua_call(L, 1, 1);			// call f(t[i])
		b = lua_toboolean(L, -1);	// get result
		lua_pop(L, 1);				// remove result

		if (b) {
			lua_rawgeti(L, 1, i);
			lua_rawseti(L, 3, ++r);
		}
	}

	return 1;
}


int l_split(lua_State* L) {
	const char* s	= luaL_checkstring(L, 1);	// subject
	const char* sep = luaL_checkstring(L, 2);	// separator
	const char* e	= NULL;
	int i = 1;

	lua_newtable(L);	// result table

	// repeat for each separator
	while ((e = strchr(s, *sep)) != NULL) {
		lua_pushlstring(L, s, e - s);	// push substring
		lua_rawseti(L, -2, i++);		// insert it in table
		s = e + 1;						// skip separator
	}

	// insert last substring
	lua_pushstring(L, s);
	lua_rawseti(L, -2, i);

	return 1;	// return the table
}

// support string contain \0
int l_split_ex(lua_State *L) {	
	size_t slen = 0;
	size_t seplen = 0;
	const char* s = luaL_checklstring(L, 1, &slen);
	const char* sep = luaL_checklstring(L, 2, &seplen);
	const char* e = NULL;
	const char* t = s + slen;
	int i = 1;

	lua_newtable(L); // result table

	// repeat for each separator
	while((e = memchr(s, *sep, slen)) != NULL) {
		lua_pushlstring(L, s, e - s);	// push substring
		lua_rawseti(L, -2, i++);		// insert it in table
		s = e + 1;						// skip separator
	}

	// insert last substring
	lua_pushlstring(L, s, t - s);
	lua_rawseti(L, -2, i);

	return 1;	// return the table
}

int t_concat(lua_State *L) {
	luaL_Buffer b;
	int i = 0;
	int n = 0;

	luaL_checktype(L, 1, LUA_TTABLE);
	n = luaL_len(L, 1);

	luaL_buffinit(L, &b);

	for (i = 1; i <= n; ++i) {
		lua_rawgeti(L, 1, i);	// get string from table
		luaL_addvalue(&b);		// add it to the buffer
	}

	luaL_pushresult(&b);

	return 1;
}

int my_concat(lua_State *L) {
	int num_of_argument = lua_gettop(L);
    lua_concat(L, num_of_argument);
	return 1;
}

int my_getn(lua_State *L) {
	int n = 0;

	luaL_checktype(L, 1, LUA_TTABLE);
	n = (int)lua_rawlen(L, -1);
	lua_pushinteger(L, n);

	return 1;
}

static int counter(lua_State *L) {
	int val = (int)lua_tointeger(L, lua_upvalueindex(1)); // old value
	lua_pushinteger(L, ++val);                       // new value
	lua_pushvalue(L, -1);                            // duplicate it
	lua_replace(L, lua_upvalueindex(1));             // update upvalue
	return 1;                                        // return new value
}

int create_counter(lua_State *L) {
    // initial value for upvalue
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

static const struct luaL_Reg test_lib[] = {
	{"summation", summation},
	{"my_pack", my_pack},
	{"my_reverse", my_reverse},
	{"my_foreach", my_foreach},
	{"l_map", l_map},
	{"l_split", l_split},
	{"l_split_ex", l_split_ex},
	{"t_concat", t_concat},
	{"l_filter", l_filter},
	{"my_concat", my_concat},
	{"my_getn", my_getn},
	{"create_counter", create_counter},
	{"t_tuple", t_tuple},
	{NULL, NULL},
};

int luaopen_testlib(lua_State *L) {
	luaL_newlib(L, test_lib);
	return 1;
}

