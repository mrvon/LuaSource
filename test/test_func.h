#pragma once

void test_push();
void test_stack();
void test_reg();
void load_conf(lua_State *L, const char *fname);
void test_conf();
int simple_interpreter(void);
void stack_dump(lua_State *L);
void error(lua_State* L, const char* fmt, ...);
int l_sin(lua_State* L);
int summation(lua_State* L);
int my_pack(lua_State* L);
int my_reverse(lua_State* L);
int my_foreach(lua_State* L);
int l_map(lua_State* L);
int l_filter(lua_State* L);
int l_split(lua_State* L);
int t_concat(lua_State *L);
int new_counter(lua_State *L);
int t_tuple(lua_State *L);