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
void test_newconf();
int simple_interpreter(void);
