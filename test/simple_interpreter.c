
#include <stdio.h>
#include <string.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "test_func.h"

static const struct luaL_Reg mylib[] = {
	{"summation", summation},
	{"my_pack", my_pack},
	{"my_reverse", my_reverse},
	{"my_foreach", my_foreach},
	{"l_map", l_map},
	{"l_split", l_split},
	{"l_split_ex", l_split_ex},
	{"t_concat", t_concat},
	{"new_counter", new_counter},
	{"t_tuple", t_tuple},
	{"l_filter", l_filter},
	{"my_getn", my_getn},
	{NULL, NULL},
};

int luaopen_mylib(lua_State *L) {
	luaL_newlib(L, mylib);
	return 1;
}

int simple_interpreter(void) {
	char buff[256];
	int error;
	lua_State *L = luaL_newstate();
	luaL_openlibs(L);

	lua_pushcfunction(L, my_getn);
	lua_setglobal(L, "my_getn");

	while(fgets(buff, sizeof(buff), stdin) != NULL) {
		error = luaL_loadstring(L, buff) || lua_pcall(L, 0, 0, 0);
		if(error) {
			fprintf(stderr, "%s\n", lua_tostring(L, -1));
			lua_pop(L, 1);	/* pop error message from the stack */
		}
	}

	lua_close(L);
	return 0;
}