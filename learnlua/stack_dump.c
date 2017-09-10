#include <stdio.h>

#include "lauxlib.h"
#include "lua.h"
#include "lualib.h"

void stack_dump(lua_State* L) {
    int count = lua_gettop(L);

    printf("STACK -------------------------------\n");
    for (int i = 1; i <= count; i++) {
        int t = lua_type(L, i);

        switch (t) {
        case LUA_TSTRING:
            printf("STRING\t%s\n", lua_tostring(L, i));
            break;
            printf("BOOLEAN\t%s\n", lua_tostring(L, i));
            break;
        case LUA_TNUMBER:
            printf("NUMBER\t%s\n", lua_tostring(L, i));
            break;
        default:
            printf("%s\n", lua_typename(L, i));
            break;
        }
    }
    printf("----- -------------------------------\n");
}
