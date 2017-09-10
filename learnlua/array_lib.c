#include "lauxlib.h"
#include "limits.h"
#include "lua.h"

#define BITS_PER_WORD (CHAR_BIT * sizeof(unsigned int))
#define INDEX_WORD(i) ((unsigned int)(i) / BITS_PER_WORD)
#define INDEX_BIT(i) (1 << ((unsigned int)(i) % BITS_PER_WORD))

#define METATABLE_NAME "LuaBook.Array"
#define CHECK_ARRAY(L, index)                                                  \
    (BitArray*)luaL_checkudata(L, index, METATABLE_NAME)

typedef struct BitArray {
    int size;
    unsigned int values[1];
} BitArray;

static int newarray(lua_State* L) {
    int i;
    size_t nbytes;
    BitArray* a;

    int n = luaL_checkint(L, 1);
    luaL_argcheck(L, n >= 1, 1, "invalid size");

    nbytes = sizeof(BitArray) + INDEX_WORD(n - 1) * sizeof(unsigned int);
    a = (BitArray*)lua_newuserdata(L, nbytes);

    a->size = n;

    for (i = 0; i <= INDEX_WORD(n - 1); ++i) {
        a->values[i] = 0;
    }

    luaL_setmetatable(L, METATABLE_NAME);

    return 1;
}

static int unionarray(lua_State* L) {
    int i;
    int j;
    int nbytes;

    BitArray* a = (BitArray*)CHECK_ARRAY(L, 1);
    BitArray* b = (BitArray*)CHECK_ARRAY(L, 2);

    if (a->size < b->size) {
        BitArray* tmp = a;
        a = b;
        b = tmp;
    }

    nbytes = sizeof(BitArray) + INDEX_WORD(a->size - 1) * sizeof(unsigned int);

    BitArray* c = (BitArray*)lua_newuserdata(L, nbytes);
    c->size = a->size;

    j = INDEX_WORD(b->size - 1);
    for (i = 0; i <= INDEX_WORD(a->size - 1); ++i) {
        if (i > j) {
            c->values[i] = a->values[i];
        } else {
            c->values[i] = a->values[i] | b->values[i];
        }
    }

    luaL_setmetatable(L, METATABLE_NAME);

    return 1;
}

static int intersectionarray(lua_State* L) {
    int i;
    int j;
    int nbytes;

    BitArray* a = (BitArray*)CHECK_ARRAY(L, 1);
    BitArray* b = (BitArray*)CHECK_ARRAY(L, 2);

    if (a->size < b->size) {
        BitArray* tmp = a;
        a = b;
        b = tmp;
    }

    nbytes = sizeof(BitArray) + INDEX_WORD(a->size - 1) * sizeof(unsigned int);

    BitArray* c = (BitArray*)lua_newuserdata(L, nbytes);
    c->size = a->size;

    j = INDEX_WORD(b->size - 1);
    for (i = 0; i <= INDEX_WORD(a->size - 1); ++i) {
        if (i > j) {
            c->values[i] = a->values[i];
        } else {
            c->values[i] = a->values[i] & b->values[i];
        }
    }

    luaL_setmetatable(L, METATABLE_NAME);

    return 1;
}

static unsigned int* getindex(lua_State* L, unsigned int* mask) {
    BitArray* a = (BitArray*)CHECK_ARRAY(L, 1);
    int index = luaL_checkint(L, 2) - 1;

    luaL_argcheck(L, a != NULL, 1, "'array' expected");
    luaL_argcheck(L, 0 <= index && index < a->size, 2, "index out of range");

    (*mask) = INDEX_BIT(index);

    return &a->values[INDEX_WORD(index)];
}

static int setarray(lua_State* L) {
    unsigned int mask;
    unsigned int* base = getindex(L, &mask);

    luaL_checktype(L, 3, LUA_TBOOLEAN);

    if (lua_toboolean(L, 3)) {
        (*base) |= mask;
    } else {
        (*base) &= ~mask;
    }

    return 0;
}

static int getarray(lua_State* L) {

    unsigned int mask;
    unsigned int* base = getindex(L, &mask);
    lua_pushboolean(L, (*base) & mask);

    return 1;
}

static int getsize(lua_State* L) {
    BitArray* a = (BitArray*)CHECK_ARRAY(L, 1);
    lua_pushinteger(L, a->size);
    return 1;
}

static int array2string(lua_State* L) {
    luaL_Buffer b;
    int i;
    BitArray* a = (BitArray*)CHECK_ARRAY(L, 1);

    luaL_buffinit(L, &b);

    lua_pushfstring(L, "Array Size(%d)\t", a->size);
    luaL_addstring(&b, lua_tostring(L, -1));
    lua_pop(L, 1);

    luaL_addstring(&b, "{ ");

    for (i = a->size - 1; i >= 0; --i) {
        if (a->values[INDEX_WORD(i)] & INDEX_BIT(i)) {
            luaL_addstring(&b, "1");
        } else {
            luaL_addstring(&b, "0");
        }
    }

    luaL_addstring(&b, " }");

    luaL_pushresult(&b);

    return 1;
}

static const struct luaL_Reg array_lib_f[] = {
    { "new", newarray },
    { "union", unionarray },
    { "intersection", intersectionarray },
    { NULL, NULL },
};

static const struct luaL_Reg array_lib_m[] = {
    { "__newindex", setarray },
    { "__index", getarray },
    { "__len", getsize },
    { "__tostring", array2string },
    { NULL, NULL },
};

int luaopen_array_lib(lua_State* L) {
    luaL_newmetatable(L, METATABLE_NAME);
    luaL_setfuncs(L, array_lib_m, 0);
    luaL_newlib(L, array_lib_f);
    return 1;
}
