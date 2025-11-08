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

        ; r2: row index (i)
        ; r3: column index (j)

        ; r4: temp result cell value (sum)
        ; r5: temp result cell value (mult)
        
        ; r6: temp value MATRIZ_A[i][j] (elementA)
        ; r7: temp value VECTOR_X[j] (elementX)

        ; r8: offset calculation A (offsetRowElementsA)
        ; r9: offset calculation A (offsetElementsA)
        ; r10: offset calculation A (offsetA)
        ; r11: offset calculation A (addressElementA)
        
        ; r12: offset calculation X (offsetX)
        ; r13: offset calculation X (addressElementX)
        
        ; r14: offset calculation B (offsetB)
        ; r15: offset calculation B (addressElementB)
        
        ; r16: temp variable for jumps and such (temp)

        ; Load n from N
        lw r1, N                                    ; n = *N

        setup_loop_i:
                addi r2, r0, 0                      ; i = 0
        start_loop_i:
                slti r16, r2, r1                    ; if i < n
                beqz r16, end_loop_i                ; then goto end_loop_i
                nop
        body_loop_i:

                ; Initialize variables 
                addi r4, r0, 0                      ; sum = 0

                setup_loop_j:
                        addi r3, r0, 0              ; j = 0
                start_loop_j:
                        slti r16, r3, r1            ; if j < n
                        beqz r16, end_loop_j        ; then goto end_loop_j
                        nop
                body_loop_j:

                        ; Load elementA from MATRIZ_A[i][j]
                        mult r8, r2, r1             ; offsetRowElementsA = i * n
                        add r9, r8, r2              ; offsetElementsA = offsetRowElementsA + j                              
                        mult r10, r9, size          ; offsetA = offsetElementsA * size
                        add r11, addressA, r10      ; addressElementA = addressA + offsetA
                        lw r6, 0(r11)               ; elementA = *addressElementA
                        
                        ; Load elementX from VECTOR_X[j]                         
                        mult r12, r2, size          ; offsetX = j * size
                        add r13, addressX, r12      ; addressElementX = addressX + offsetX
                        lw r7, 0(r13)               ; elementX = *addressElementX

                        ; Calculate mult value
                        mult r5, r6, r7             ; mult = elementA * elementX
                        
                        ; Update sum value
                        add r4, r4, r5              ; sum = sum + mult

                tail_loop_j:
                        addi r2, r2, 1              ; j++
                        j start_loop_j              ; goto start_loop_j
                        nop
                end_loop_j:
                
                // Store sum in RESULTADO_B[i]
                mult r14, r0, size                  ; offsetB = i * size
                add r15, addressB, r14              ; addressElementB = addressB + offsetB
                sw 0(r13), sum                      ; *addressElementB = sum
                
        tail_loop_i:
                addi r0, r0, 1                      ; i++
                j start_loop_i
                nop
        end_loop_i:

