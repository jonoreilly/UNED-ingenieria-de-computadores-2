# DLXV Assembly Programming Guide

This guide provides instructions and best practices for writing assembly code for the DLXV architecture.

For more in-depth documentation and reference, see [Manual_WinDLXV.txt](./Manual_WinDLXV.txt) located in the workspace.

## Register Set

The DLXV processor has:
- 32 scalar general-purpose registers:
    - r0: Always contains 0 (cannot be written)
    - r1-r31: General purpose registers
- 32 scalar floating point registers:
    - f0-f31: Floating point registers
- 8 vector registers (64 words each):
    - v0-v7

Special registers:
- FPSR (Floating-Point Status Register): 1 bit register used for floating point comparisons and exceptions
- VLR (Vector-Length Register): controls the length of any vector operation
- VM (Vector-Mask Register): 64 bit mask to decide what elements of the vector to apply the operation to

Common register conventions:
- r26-r27 (K0-K1): Reserved for OS
- r29 (SP): Stack pointer
- r31 (RA): Return address

## Basic Instruction Format

Most instructions follow this format:
```assembly
OPCODE rd, rs1, rs2    ; Register format
OPCODE rd, rs1, imm    ; Immediate format
```

Where:
- OPCODE: The instruction mnemonic
- rd: Destination register
- rs1, rs2: Source registers
- imm: Immediate value

## Instruction Categories

### Data Transfer
- `lw rd, offset(rs1)` - Load word
- `sw offset(rs1), rs2` - Store word
- `lb, lh, lbu, lhu` - Load byte/halfword (signed/unsigned)
- `sb, sh` - Store byte/halfword
- `lf, ld, sf, sd` - Load/store floating point (single/double)
- `lv, sv` - Load/store vector

### Arithmetic/Logic
- `add rd, rs1, rs2` - Add (signed)
- `addu rd, rs1, rs2` - Add (unsigned)
- `sub, subu, mult, multu, div, divu` - Subtract, multiply, divide (signed/unsigned)
- `and, or, xor` - Logical operations
- `sll, srl, sra` - Shifts
- `addi, addiu, subi, subui` - Immediate operations
- `lhi` - Load high immediate

### Comparison
- `slt, sgt, sle, sge, seq, sne` - Set on condition
- Immediate forms: `slti`, etc.

### Control Flow
- `beqz rs1, label` - Branch if rs1 == 0
- `bnez rs1, label` - Branch if rs1 != 0
- `j label` - Jump
- `jal label` - Jump and link (stores return address in r31)
- `jr rs1` - Jump register
- `jalr rs1` - Jump and link register
- `trap imm` - System call

### Memory Addressing Modes

1. Register Indirect:
```assembly
lw r1, 0(r2)      ; Load from address in r2
```

2. Base + Displacement:
```assembly
lw r1, 100(r2)    ; Load from r2 + 100
```

## Assembly Directives

- `.data [address]` - Data section (optionally at address)
- `.text [address]` - Code section (optionally at address)
- `.word` - Define word (32 bits)
- `.half` - Define halfword (16 bits)
- `.byte` - Define byte (8 bits)
- `.space` - Reserve space (in bytes)
- `.align n` - Align to 2^n bytes
- `.ascii` - Store string (no NUL)
- `.asciiz` - Store string (NUL-terminated)
- `.float`, `.double` - Store floating point values
- `.org address` - Set memory origin

## Common Programming Patterns

### Function Call
```assembly
; Caller
jal function       ; Jump and link
nop                ; Delay slot

; Function
function:
    sw r31, 0(r29)  ; Save return address
    ... function body ...
    lw r31, 0(r29)  ; Restore return address
    jr r31          ; Return
    nop             ; Delay slot
```

### Loop Example
```assembly
    addi r1, r0, 0    ; Initialize counter
loop:
    ... loop body ...
    addi r1, r1, 1    ; Increment counter
    slti r2, r1, 10   ; Compare with 10
    bnez r2, loop     ; Branch if not done
    nop               ; Delay slot
```

### Array Access
```assembly
    ; Assuming array base in r2, index in r1
    sll r3, r1, 2     ; Multiply index by 4 (word size)
    add r3, r2, r3    ; Add to base address
    lw r4, 0(r3)      ; Load array element
```

## Best Practices

1. Always initialize registers before use
2. Use meaningful label names
3. Include comments for clarity (use `;` for comments)
4. Handle delay slots carefully (always use `nop` after branch/jump)
5. Preserve registers according to calling convention
6. Align data appropriately
7. Use pseudo-instructions when available for better readability

## Common Pitfalls

1. Forgetting to handle delay slots
2. Not saving/restoring registers in functions
3. Incorrect memory alignment
4. Using r0 as a destination (always stays 0)
5. Not initializing variables
6. Incorrect branch conditions

## Debugging Tips

1. Use single-stepping in WinDLXV
2. Watch register values
3. Check memory contents
4. Verify branch conditions
5. Ensure proper stack management

## System Calls (Traps)

- `trap 0`: End program (without finishing pending operations)
- `trap 1`: Open file
- `trap 2`: Close file
- `trap 3`: Read from file or stdin
- `trap 4`: Write to file
- `trap 5`: Formatted output (like printf)
- `trap 6`: End program (finish all operations)

For trap parameter passing, place the address of the first parameter in r14, and subsequent parameters at r14+4, r14+8, etc. Return values are in r1. See manual for details and examples.
