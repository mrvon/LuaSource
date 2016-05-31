int bitcount(unsigned x)
{
    int b;

    for (b = 0; x != 0; x >>= 1) {
        if (x & 01)
            b++;
    }

    return b;
}

int fastbitcount(unsigned x)
{
    int b = 0;

    while(x != 0) {
        x &= (x - 1);
        b++;
    }

    return b;
}
