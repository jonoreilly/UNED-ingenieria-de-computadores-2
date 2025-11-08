.data
        ; matriz NxN
        MATRIZ_A: .double 11,12,13,21,22,23,31,33,33
        
        ; vector Nx1 
        VECTOR_X: .double 1,2,3
        
        ; vector Nx1
        RESULTADO_B: .space 24
        
        ; M = N = 3. P = 1
        N: .word 3
        
.text

        ; r0: valor 0

        ; r1: value of N (n)
        ; r2: size of elements (elementSize)

        ; r3: row index (i)
        ; r4: column index (j)

        ; r5: temp result cell value (sum)
        ; r6: temp result cell value (mult)
        
        ; r7: temp value MATRIZ_A[i][j] (elementA)
        ; r8: temp value VECTOR_X[j] (elementX)

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

        ; Set element size to 8 bytes (.double)
        addi r2, r0, 8                                  ; elementSize = 8


        setup_loop_i:
                addi r3, r0, 0                          ; i = 0
        start_loop_i:
                slti r17, r3, r1                        ; if i < n
                beqz r17, end_loop_i                    ; then goto end_loop_i
                nop
        body_loop_i:

                ; Initialize variables 
                addi r5, r0, 0                          ; sum = 0

                setup_loop_j:
                        addi r4, r0, 0                  ; j = 0
                start_loop_j:
                        slti r17, r4, r1                ; if j < n
                        beqz r17, end_loop_j            ; then goto end_loop_j
                        nop
                body_loop_j:

                        ; Load elementA from MATRIZ_A[i][j]
                        mult r9, r3, r1                 ; offsetRowElementsA = i * n
                        add r10, r9, r3                 ; offsetElementsA = offsetRowElementsA + j                              
                        mult r11, r10, r2               ; offsetA = offsetElementsA * elementSize
                        add r12, addressA, r11          ; addressElementA = addressA + offsetA
                        lw r7, 0(r12)                   ; elementA = *addressElementA
                        
                        ; Load elementX from VECTOR_X[j]                         
                        mult r13, r3, r2                ; offsetX = j * elementSize
                        add r14, addressX, r13          ; addressElementX = addressX + offsetX
                        lw r8, 0(r14)                   ; elementX = *addressElementX

                        ; Calculate mult value
                        mult r6, r7, r8                 ; mult = elementA * elementX
                        
                        ; Update sum value
                        add r5, r5, r6                  ; sum = sum + mult

                tail_loop_j:
                        addi r3, r3, 1                  ; j++
                        j start_loop_j                  ; goto start_loop_j
                        nop
                end_loop_j:
                
                // Store sum in RESULTADO_B[i]
                mult r15, r0, r2                        ; offsetB = i * elementSize
                add r16, addressB, r15                  ; addressElementB = addressB + offsetB
                sw 0(r14), sum                          ; *addressElementB = sum
                
        tail_loop_i:
                addi r0, r0, 1                          ; i++
                j start_loop_i
                nop
        end_loop_i:

