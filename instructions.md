# Instruction format
OPP - REG
5 bits - 2 bits - 1 type
0 -> Instr, 1 -> Data

# INSTRCTIONS

NOP - 00000  - 0x0   -   No operation
LI  - 00001  - 0x1   -   Move from C
SI  - 00010  - 0x2   -   Move to C

LB  - 00011  - 0x3   -   Load byte
SB  - 00100  - 0x4   -   Store byte

J   - 00101  - 0x5   -   Jump to address in C

BEQ - 00110  - 0x6   -   Branch if equal
BNQ - 00111  - 0x7   -   Branch if not equal
BGT - 01000  - 0x8   -   Branch if greater than

Add stall instruction/signal
Unalocated
xxx
XXX - 01001  - 0x9   -   XXX
XXX - 01010  - 0xA   -   XXX
XXX - 01011  - 0xB   -   XXX
XXX - 01100  - 0xC   -   XXX
XXX - 01101  - 0xD   -   XXX
XXX - 01110  - 0xE   -   XXX
xxx

AND - 10000  - 0x10   -   Bit wise AND
OR  - 10001  - 0x11   -   Bit wise OR
XOR - 10010  - 0x12   -   Bit wise XOR
NOT - 10011  - 0x13   -   Bit wise NOT
ADD - 10100  - 0x14   -   Addition
SUB - 10101  - 0x15   -   Subtraction
MULT- 10110  - 0x16   -   Multiplication
DIV - 10111  - 0x17   -   Division          - NOT IMPLEMENTED
SR  - 11000  - 0x18   -   Shift right
SL  - 11001  - 0x19   -   Shift left
EQ  - 11010  - 0x1A   -   Equal
GT  - 11011  - 0x1B   -   Greater than




SA  - 11100  - 0x1C   -   Move from A       - NOT IMPLEMENTED, RESERVED!
LA  - 11101  - 0x1D   -   Move to A         - NOT IMPLEMENTED, RESERVED!
SBR - 11110  - 0x1E   -   Move from B       - NOT IMPLEMENTED, RESERVED!
LBR - 11111  - 0x1F   -   Move to B         - NOT IMPLEMENTED, RESERVED!



# REGISTERS
A   - 0x0
B   - 0x1
r0  - 0x2
r1  - 0x3
C   - Outside of ALU, in CU


# Memory mapping
Memory in addresses 0x0 to 0x7F. The rest is for other blocks or peripherals
Program memory
0x0
0x3F
Data memory
0x40
0x7F