#include <lua.h>
#include <lauxlib.h>
#include <zlib.h>
#include <assert.h>

/*
 * (string) / (msg, sz)
 * (msg, sz)
 */
static int ldeflate(lua_State *L) {
    luaL_Buffer buff;
    z_stream stream;
    void *src_buff;
    unsigned long src_len;
    int ret;

    if (lua_isnoneornil(L, 1)) {
        lua_pushnil(L);
        return 1;
    }

    if (lua_type(L, 1) == LUA_TSTRING) {
        size_t sz;
        src_buff = (void*)lua_tolstring(L, 1, &sz);
        src_len = (unsigned long)sz;
    } else {
        src_buff = lua_touserdata(L, 1);
        src_len = (unsigned long)luaL_checkinteger(L, 2);
    }

    if (src_len == 0) {
        lua_pushnil(L);
        return 1;
    }

    if (src_buff == NULL) {
        return luaL_error(L, "deflate null pointer");
    }

    lua_settop(L, 0);

    /* allocate deflate state */
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;

    ret = deflateInit(&stream, Z_DEFAULT_COMPRESSION);

    if (ret != Z_OK) {
        lua_pushnil(L);
        return 1;
    }

    luaL_buffinit(L, &buff);

    stream.avail_in = src_len;
    stream.next_in = src_buff;

    do {
        stream.avail_out = LUAL_BUFFERSIZE;
        stream.next_out = (unsigned char*)luaL_prepbuffer(&buff);

        ret = deflate(&stream, Z_FINISH);
        assert(ret != Z_STREAM_ERROR);

        luaL_addsize(&buff, LUAL_BUFFERSIZE - stream.avail_out);
    } while (stream.avail_out == 0);

    /* stream will be complete */
    assert(ret == Z_STREAM_END);
    /* clean up and return */
    deflateEnd(&stream);

    luaL_pushresult(&buff);
    return 1;
}

/*
 * (string) / (msg, sz)
 * (msg, sz)
 */
static int linflate(lua_State *L) {
    luaL_Buffer buff;
    z_stream stream;
    void *src_buff;
    unsigned long src_len;
    int ret;

    if (lua_isnoneornil(L, 1)) {
        lua_pushnil(L);
        return 1;
    }

    if (lua_type(L, 1) == LUA_TSTRING) {
        size_t sz;
        src_buff = (void*)lua_tolstring(L, 1, &sz);
        src_len = (unsigned long)sz;
    } else {
        src_buff = lua_touserdata(L, 1);
        src_len = (unsigned long)luaL_checkinteger(L, 2);
    }

    if (src_len == 0) {
        lua_pushnil(L);
        return 1;
    }

    if (src_buff == NULL) {
        return luaL_error(L, "inflate null pointer");
    }

    lua_settop(L, 0);

    /* allocate inflate state */
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;
    stream.avail_in = 0;
    stream.next_in = Z_NULL;

    ret = inflateInit(&stream);

    if (ret != Z_OK) {
        lua_pushnil(L);
        return 1;
    }

    luaL_buffinit(L, &buff);

    stream.avail_in = src_len;
    stream.next_in = src_buff;

    do {
        stream.avail_out = LUAL_BUFFERSIZE;
        stream.next_out = (unsigned char*)luaL_prepbuffer(&buff);

        ret = inflate(&stream, Z_NO_FLUSH);
        assert(ret != Z_STREAM_ERROR);

        switch(ret) {
            case Z_NEED_DICT:
                ret = Z_DATA_ERROR;
                /* fall through */
            case Z_DATA_ERROR:
            case Z_MEM_ERROR:
                inflateEnd(&stream);
                lua_pushnil(L);
                return ret;
        }

        luaL_addsize(&buff, LUAL_BUFFERSIZE - stream.avail_out);
    } while (stream.avail_out == 0);

    /* clean up and return */
    inflateEnd(&stream);

    luaL_pushresult(&buff);
    return 1;
}

/*
 * (string)
 */
static int lversion(lua_State *L) {
    const char* str = zlibVersion();
    lua_pushstring(L, str);
    return 1;
}

static struct luaL_Reg zlib[] = {
  {"deflate", ldeflate},
  {"inflate", linflate},
  {"version", lversion},
  {NULL, NULL}
};

int luaopen_zlib (lua_State *L) {
    lua_newtable(L);
    luaL_setfuncs(L, zlib, 0);
    return 1;
}
