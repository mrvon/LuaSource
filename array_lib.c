#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

static int test(lua_State *L)
{
    lua_pushstring(L, "Hell_ world");
    return 1;
}

static const struct luaL_Reg array_lib[] = {
    {"test", test},
	{NULL, NULL},
};

int luaopen_array_lib(lua_State *L)
{
    luaL_newlib(L, array_lib);
    return 1;
}
