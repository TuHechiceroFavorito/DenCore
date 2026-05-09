// Set sq = 25
LC 60h
LI A
LC 74h
SB A

// Set x1 = 1
LC 20h
LI A
LC 70h
SB A

// Set x2 = 10
LC 3Fh   // x2
LI A
LC 71h
SB A

// Calculate y1
LC 70h
LB A
LB B
MULT A
LC 74h    // Find the square root of this number
LB B
SUB A
LC 72h
SB A

// Calculate y2
LC 71h
LB A
LB B
MULT A
LC 74h    // Find the square root of this number
LB B
SUB A
LC 73h
SB A

LOOP:
// Check if maximum resolution reached
LC 70h
LB B
LC 71h
LB A
SUB A
LC 1h
LI B
BEQ SOLUTION

// Find middle point xm
LC 70h
LB A
LC 71h
LB B
ADD A
SR A
LC 75h
SB A

// Calculate ym
LB B
MULT A
LC 74h
LB B
SUB A
LC 76h
SB A

// Check if solution reached
LC 0
LI B
BEQ SOLUTION

// Update new value depending on sign
LC 76h
LB A
LC 0h
LI B
BGT UPX2

UPX1:
// Update x1 to xm
LC 75h
LB A
LC 70h
SB A
// Update y1 to ym
LC 76h
LB A
LC 72h
SB A

J LOOP // Repeat loop

UPX2:
// Update x2 to xm
LC 75h
LB A
LC 71h
SB A
// Update y2 to ym
LC 76h
LB A
LC 73h
SB A

J LOOP // Repeat loop

// Infinite loop of doing nothing
// This avoids the PC going over to the section where the data is stored
SOLUTION:
LC 75h
LB r0

END:
NOP
J END

