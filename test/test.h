#pragma once
#include <stdio.h>
#include <string.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

void error(lua_State* L, const char* fmt, ...);
void test_push();
void test_stack();
void test_reg();
void load_conf(lua_State *L, const char *fname);
void test_conf();
int simple_interpreter(void);
int l_sin(lua_State* L);
int summation(lua_State* L);
int my_pack(lua_State* L);
int my_reverse(lua_State* L);
int my_foreach(lua_State* L);
int l_map(lua_State* L);
int l_filter(lua_State* L);
int l_split(lua_State* L);
int l_split_ex(lua_State *L);
int t_concat(lua_State *L);
int create_counter(lua_State *L);
int t_tuple(lua_State *L);
int my_concat(lua_State *L);
int my_getn(lua_State *L);
