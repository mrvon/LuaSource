#pragma once

void test_push();
void test_stack();
void load_conf(lua_State *L, const char *fname);
void test_conf();
int simple_interpreter(void);
void stack_dump(lua_State *L);
void error(lua_State* L, const char* fmt, ...);
int l_sin(lua_State* L);
int summation(lua_State* L);
int luaopen_mylib(lua_State *L);
int my_pack(lua_State* L);