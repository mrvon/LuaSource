#include <stdio.h>

#include "lauxlib.h"
#include "lua.h"
#include "lualib.h"

void stack_dump(lua_State* L) {
    int count = lua_gettop(L);

    printf("STACK ---------------------------------------------------------\n");
    for (int i = 1; i <= count; i++) {
        int t = lua_type(L, i);

        switch (t) {
        case LUA_TNIL:
            printf("LUA_TNIL\n");
            break;
        case LUA_TBOOLEAN:
            printf("LUA_TBOOLEAN       %40d\n", lua_toboolean(L, i));
            break;
        case LUA_TLIGHTUSERDATA:
            printf("LUA_TLIGHTUSERDATA %40d\n", lua_toboolean(L, i));
            break;
        case LUA_TNUMBER:
            printf("LUA_TNUMBER        %40f\n", lua_tonumber(L, i));
            break;
        case LUA_TSTRING:
            printf("LUA_TSTRING        %40s\n", lua_tostring(L, i));
            break;
        case LUA_TTABLE:
            printf("LUA_TTABLE         %40s\n", lua_tostring(L, i));
            break;
        case LUA_TFUNCTION:
            printf("LUA_TFUNCTION      %40s\n", lua_typename(L, i));
            break;
        case LUA_TUSERDATA:
            printf("LUA_TUSERDATA      %40s\n", lua_typename(L, i));
            break;
        case LUA_TTHREAD:
            printf("LUA_TTHREAD        %40s\n", lua_typename(L, i));
            break;
        default:
            break;
        }
    }
    printf("----- ---------------------------------------------------------\n");
}
