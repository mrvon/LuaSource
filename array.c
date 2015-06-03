#include <limits.h>
#include <stdio.h>

#define BITS_PER_WORD   (CHAR_BIT * sizeof(unsigned int))
#define I_WORD(i)       ((unsigned int)(i) / BITS_PER_WORD)
#define I_BIT(i)        (1 << ((unsigned int)(i) % BITS_PER_WORD))

typedef struct NumArray = {
    int size;
    unsigned int values[1]; /* variable part */
} NumArray;

static int newarray(lua_State *L) {
    int i;
    size_t nbytes;
    NumArray *a;

    int n = luaL_checkint(L, 1);
    luaL_argcheck(L, n >= 1, 1, "invalid size");
    nbytes = sizeof(NumArray) + I_WORD(n - 1) * sizeof(unsigned int);
    a = (NumArray *) lua_newuserdata(L, nbytes);

    a->size = n;
    for (i = 0; i <= I_WORD(n - 1); ++i) {
        a->values[i] = 0;
    }

    return 1; /* new userdatum is already on the stack */
}
static int setarray(lua_State *L) {
    NumArray *a = (NumArray*) lua_touserdata(L, 1);
    int index = luaL_checkint(L, 2) - 1;

    luaL_argcheck(L, a != NULL, 1, "'array' expected");
    luaL_argcheck(L, 0 <= index && index < a->size, 2, "index out of range");
    luaL_checkany(L, 3);

    if (lua_toboolean(L, 3)) {
        a->values[I_WORD(index)] |= I_BIT(index); /* set bit */
    }
    else {
        a->values[I_WORD(index)] &= ~I_BIT(index); /* reset bit */
    }
}

static int getarray(lua_State *L) {
    NumArray *a = (NumArray*) lua_touserdata(L, 1);
    int index = luaL_checkint(L, 2) - 1;

    luaL_argcheck(L, a != NULL, 1, "'array' expected");
    luaL_argcheck(L, 0 <= index && index < a->size, 2, "index out of range");
    lua_pushboolean(L, a->values[I_WORD(index)] & I_BIT(index));

    return 1;
}

static int getsize(lua_State *L) {
    NumArray *a = (NumArray*) lua_touserdata(L, 1);
    luaL_argcheck(L, a != NULL, 1, "'array' expected");
    lua_pushinterger(L, a->size);

    return 1;
}

static const struct luaL_Reg arraylib[] = {
    {"new", newarray},
    {"set", setarray},
    {"get", getarray},
    {"size", getsize},
    {NULL, NULL},
};

int luaopen_array(lua_State *L) {
    luaL_newlib(L, arraylib)
    return 1;
}
