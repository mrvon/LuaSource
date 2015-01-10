#include <stdio.h>
#include <string.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "test_func.h"

int simple_interpreter(void) {
	char buff[256];
	int error;
	lua_State *L = luaL_newstate();
	luaL_openlibs(L);

	lua_pushcfunction(L, summation);
	lua_setglobal(L, "summation");
	lua_pushcfunction(L, my_pack);
	lua_setglobal(L, "my_pack");
	lua_pushcfunction(L, my_reverse);
	lua_setglobal(L, "my_reverse");
	lua_pushcfunction(L, my_foreach);
	lua_setglobal(L, "my_foreach");
	lua_pushcfunction(L, l_map);
	lua_setglobal(L, "l_map");
	lua_pushcfunction(L, l_split);
	lua_setglobal(L, "l_split");
	
	
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