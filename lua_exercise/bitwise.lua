function printx(x)
    print(string.format("0x%X", x))
end

printx(bit32.band(0xDF, 0xFD))
printx(bit32.bor(0xD0, 0x0D))
printx(bit32.bxor(0xD0, 0xFF))
printx(bit32.bnot(0))

printx(bit32.bor(0xA, 0xA0, 0xA00))
printx(bit32.band(0xFFA, 0xFAF, 0xAFF))
printx(bit32.bxor(0, 0xAAA, 0))
printx(bit32.bor())
printx(bit32.band())
printx(bit32.bxor())
