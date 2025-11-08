# DLXV Assembly Programming Guide

This guide provides instructions and best practices for writing assembly code for the DLXV architecture.

## Register Set

The DLXV processor has 32 general-purpose registers:
- R0: Always contains 0
- R1-R31: General purpose registers
- F0-F31: Floating point registers

Common register conventions:
- R26-R27 (K0-K1): Reserved for OS
- R29 (SP): Stack pointer
- R31 (RA): Return address

## Basic Instruction Format

Most instructions follow this format:
```assembly
OPCODE Rd, Rs1, Rs2    ; Register format
OPCODE Rd, Rs1, imm    ; Immediate format
```

Where:
- OPCODE: The instruction mnemonic
- Rd: Destination register
- Rs1, Rs2: Source registers
- imm: Immediate value

## Instruction Categories

### Data Transfer
- `LW rd, offset(rs1)` - Load word
- `SW rs2, offset(rs1)` - Store word
- `LB, LH` - Load byte/halfword
- `SB, SH` - Store byte/halfword

### Arithmetic/Logic
- `ADD rd, rs1, rs2` - Add
- `SUB rd, rs1, rs2` - Subtract
- `AND, OR, XOR` - Logical operations
- `SLL, SRL, SRA` - Shifts
- `ADDI, SUBI` - Immediate operations

### Control Flow
- `BEQ rs1, rs2, label` - Branch if equal
- `BNE rs1, rs2, label` - Branch if not equal
- `J label` - Jump
- `JAL label` - Jump and link
- `JR rs1` - Jump register

### Memory Addressing Modes

1. Register Indirect:
```assembly
LW R1, 0(R2)      ; Load from address in R2
```

2. Base + Displacement:
```assembly
LW R1, 100(R2)    ; Load from R2 + 100
```

## Assembly Directives

- `.data` - Data section
- `.text` - Code section
- `.word` - Define word (32 bits)
- `.half` - Define halfword (16 bits)
- `.byte` - Define byte (8 bits)
- `.space` - Reserve space
- `.align` - Align to boundary

## Common Programming Patterns

### Function Call
```assembly
; Caller
JAL function       ; Jump and link
NOP               ; Delay slot

; Function
function:
    ; Save registers if needed
    SW RA, 0(SP)  ; Save return address
    ; ... function body ...
    LW RA, 0(SP)  ; Restore return address
    JR RA         ; Return
    NOP           ; Delay slot
```

### Loop Example
```assembly
    ADDI R1, R0, 0    ; Initialize counter
loop:
    ; Loop body
    ADDI R1, R1, 1    ; Increment counter
    SLTI R2, R1, 10   ; Compare with 10
    BNE R2, R0, loop  ; Branch if not done
    NOP              ; Delay slot
```

### Array Access
```assembly
    ; Assuming array base in R2, index in R1
    SLL R3, R1, 2     ; Multiply index by 4 (word size)
    ADD R3, R2, R3    ; Add to base address
    LW R4, 0(R3)      ; Load array element
```

## Best Practices

1. Always initialize registers before use
2. Use meaningful label names
3. Include comments for clarity
4. Handle delay slots carefully
5. Preserve registers according to calling convention
6. Align data appropriately
7. Use pseudo-instructions when available for better readability

## Common Pitfalls

1. Forgetting to handle delay slots
2. Not saving/restoring registers in functions
3. Incorrect memory alignment
4. Using R0 as a destination (always stays 0)
5. Not initializing variables
6. Incorrect branch conditions

## Debugging Tips

1. Use single-stepping in WinDLXV
2. Watch register values
3. Check memory contents
4. Verify branch conditions
5. Ensure proper stack management
