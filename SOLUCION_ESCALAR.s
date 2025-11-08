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

        ; r1: row index (i)
        ; r2: column index (j)

        ; r3: temp result cell value (sum)
        ; r4: temp result cell value (mult)
        
        ; r5: temp value MATRIZ_A[i][j] (elementA)
        ; r6: temp value VECTOR_X[j] (elementX)

        ; r7: offset calculation A (offsetRowElementsA)
        ; r8: offset calculation A (offsetElementsA)
        ; r9: offset calculation A (offsetA)
        ; r10: offset calculation A (addressElementA)
        
        ; r11: offset calculation X (offsetX)
        ; r12: offset calculation X (addressElementX)
        
        ; r13: offset calculation B (offsetB)
        ; r14: offset calculation B (addressElementB)
        
        ; r15: temp variable for jumps and such (temp)

        setup_loop_i:
                addi r1, r0, 0                      ; i = 0
        start_loop_i:
                slti r15, r1, N                     ; if i < N
                beqz r15, end_loop_i                ; then goto end_loop_i
                nop
        body_loop_i:

                ; Initialize variables 
                addi r3, r0, 0                      ; sum = 0

                setup_loop_j:
                        addi r2, r0, 0              ; j = 0
                start_loop_j:
                        slti r15, r2, N             ; if j < N
                        beqz r15, end_loop_j        ; then goto end_loop_j
                        nop
                body_loop_j:

                        ; Fetch MATRIZ_A[i][j]
                        mult r7, r1, N              ; offsetRowElementsA = i * N
                        add r8, r7, r1              ; offsetElementsA = offsetRowElementsA + j                              
                        mult r9, r8, size           ; offsetA = offsetElementsA * size
                        add r10, addressA, r9       ; addressElementA = addressA + offsetA
                        lw r5, 0(r10)               ; elementA = *addressElementA
                        
                        ; Fetch VECTOR_X[j]                         
                        mult r11, r1, size          ; offsetX = j * size
                        add r12, addressX, r11      ; addressElementX = addressX + offsetX
                        lw r6, 0(r12)               ; elementX = *addressElementX

                        ; Calculate mult value
                        mult r4, r5, r6             ; mult = elementA * elementX
                        
                        ; Update sum value
                        add r3, r3, r4              ; sum = sum + mult

                tail_loop_j:
                        addi r1, r1, 1              ; j++
                        j start_loop_j              ; goto start_loop_j
                        nop
                end_loop_j:
                
                // Store sum in RESULTADO_B[i]
                mult r13, r0, size                  ; offsetB = i * size
                add r14, addressB, r13              ; addressElementB = addressB + offsetB
                sw 0(r12), sum                      ; *addressElementB = sum
                
        tail_loop_i:
                addi r0, r0, 1                      ; i++
                j start_loop_i
                nop
        end_loop_i:

