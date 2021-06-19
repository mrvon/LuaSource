// clang dump_struct.c
#include <stdio.h>

struct Pos {
    int x;
    int y;
};

struct Land {
    int id;
    struct Pos pos;
};

int main() {
    struct Pos pos;
    pos.x = 1;
    pos.y = 2;
    struct Land land;
    land.id = 10;
    land.pos = pos;
    __builtin_dump_struct(&land, &printf);
    return 0;
}
