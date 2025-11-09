.data

        ; matriz NxN
        MATRIZ_A: .double 11,12,13,21,22,23,31,33,33
        
        ; vector Nx1 
        VECTOR_X: .double 1,2,3
        
        ; vector Nx1
        RESULTADO_B: .space 24
        
        ; M = N = 3. P = 1
        N: .word 3

        ; valor 0
        ZERO: .double 0
        
.text

        ; r0: value 0
        ; f0: value 0

        ; r1: value of N (n)
        ; r2: size of elements (elementSize)

        ; r3: row index (i)
        ; r4: column index (j)

        ; f2: temp result cell value (sum)
        ; f4: temp result cell value (mult)
        
        ; f6: temp value MATRIZ_A[i][j] (elementA)
        ; f8: temp value VECTOR_X[j] (elementX)

        ; r9: offset calculation A (offsetRowElementsA)
        ; r10: offset calculation A (offsetElementsA)
        ; r11: offset calculation A (offsetA)
        ; r12: offset calculation A (addressElementA)
        
        ; r13: offset calculation X (offsetX)
        ; r14: offset calculation X (addressElementX)
        
        ; r15: offset calculation B (offsetB)
        ; r16: offset calculation B (addressElementB)
        
        ; r17: temp variable for jumps and such (temp)

        ; Load n from N
        lw r1, N                                        ; n = *N
        
        ; Initialize Zero variable 
        ld f0, ZERO                                     ; zero = 0

        ; Set element size to 8 bytes (.double)
        addi r2, r0, 8                                  ; elementSize = 8

        setup_loop_i:
                addi r3, r0, 0                          ; i = 0
        start_loop_i:
                slt r17, r3, r1                         ; if i < n
                beqz r17, end_loop_i                    ; then goto end_loop_i
                nop
        body_loop_i:

                ; Initialize Sum variable 
                addd f2, f0, f0                         ; sum = 0

                setup_loop_j:
                        addi r4, r0, 0                  ; j = 0
                start_loop_j:
                        slt r17, r4, r1                 ; if j < n
                        beqz r17, end_loop_j            ; then goto end_loop_j
                        nop
                body_loop_j:

                        ; Load elementA from MATRIZ_A[i][j]
                        mult r9, r3, r1                 ; offsetRowElementsA = i * n
                        add r10, r9, r4                 ; offsetElementsA = offsetRowElementsA + j                              
                        mult r11, r10, r2               ; offsetA = offsetElementsA * elementSize
                        addi r12, r11, MATRIZ_A         ; addressElementA = offsetA + addressA
                        ld f6, 0(r12)                   ; elementA = *addressElementA
                        
                        ; Load elementX from VECTOR_X[j]                         
                        mult r13, r4, r2                ; offsetX = j * elementSize
                        addi r14, r13, VECTOR_X         ; addressElementX = offsetX + addressX
                        ld f8, 0(r14)                   ; elementX = *addressElementX

                        ; Calculate mult value
                        multd f4, f6, f8                ; mult = elementA * elementX
                        
                        ; Update sum value
                        addd f2, f2, f4                 ; sum = sum + mult

                tail_loop_j:
                        addi r3, r3, 1                  ; j++
                        j start_loop_j                  ; goto start_loop_j
                        nop
                end_loop_j:
                
                ; Store sum in RESULTADO_B[i]
                mult r15, r3, r2                        ; offsetB = i * elementSize
                addi r16, r15, RESULTADO_B              ; addressElementB = offsetB + addressB
                sd 0(r14), f2                           ; *addressElementB = sum
                
        tail_loop_i:
                addi r3, r3, 1                          ; i++
                j start_loop_i
                nop
        end_loop_i:

        trap 6