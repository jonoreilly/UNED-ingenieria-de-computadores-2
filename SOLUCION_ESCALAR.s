.data

        ; valor 0
        ZERO: .double 0

        ; matriz NxN
        MATRIZ_A: .double 11,12,13,14,15,16,21,22,23,24,25,26
        MATRIZ_A_2: .double 31,32,33,34,35,36,41,42,43,44,45,46
        MATRIZ_A_3: .double 51,52,53,54,55,56,61,62,63,64,65,66
        
        ; vector Nx1 
        VECTOR_X: .double 1,2,3,4,5,6
        
        ; vector Nx1 (resultado esperado: 301,511,721,931,1141,1351)
        RESULTADO_B: .space 48
        
        ; Size of matrix
        N: .word 6
        
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

        ; r18,r19: summary calculation
        ; f10-f30: summary
        
        ; Initialize Zero variable 
        ld f0, ZERO                                     ; zero = 0

        ; Load n from N
        lw r1, N                                        ; n = *N

        ; Set element size to 8 bytes (.double)
        addi r2, r0, 8                                  ; elementSize = 8

        setup_loop_i:
                addi r3, r0, 0                          ; i = 0
        start_loop_i:
                sge r17, r3, r1                         ; if i >= n
                bnez r17, end_loop_i                    ; then goto end_loop_i
        body_loop_i:

                ; Initialize Sum variable 
                addd f2, f0, f0                         ; sum = 0

                setup_loop_j:
                        addi r4, r0, 0                  ; j = 0
                start_loop_j:
                        sge r17, r4, r1                 ; if j >= n
                        bnez r17, end_loop_j            ; then goto end_loop_j
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
                        addi r4, r4, 1                  ; j++
                        j start_loop_j                  ; goto start_loop_j
                end_loop_j:
                
                ; Store sum in RESULTADO_B[i]
                mult r15, r3, r2                        ; offsetB = i * elementSize
                addi r16, r15, RESULTADO_B              ; addressElementB = offsetB + addressB
                sd 0(r16), f2                           ; *addressElementB = sum
                
        tail_loop_i:
                addi r3, r3, 1                          ; i++
                j start_loop_i
        end_loop_i:

        start_summary:
                addi r18, r0, RESULTADO_B               ; r18 = addressB
                slti r19, r1, 1                         ; if n < 1
                bnez r19, end_summary                   ; then goto end_summary
                ld f10, 0(r18)
                slti r19, r1, 2                         ; if n < 2
                bnez r19, end_summary                   ; then goto end_summary
                ld f12, 8(r18)
                slti r19, r1, 3                         ; if n < 3
                bnez r19, end_summary                   ; then goto end_summary
                ld f14, 16(r18)
                slti r19, r1, 4                         ; if n < 4
                bnez r19, end_summary                   ; then goto end_summary
                ld f16, 24(r18)
                slti r19, r1, 5                         ; if n < 5
                bnez r19, end_summary                   ; then goto end_summary
                ld f18, 32(r18)
                slti r19, r1, 6                         ; if n < 6
                bnez r19, end_summary                   ; then goto end_summary
                ld f20, 40(r18)
                slti r19, r1, 7                         ; if n < 7
                bnez r19, end_summary                   ; then goto end_summary
                ld f22, 48(r18)
                slti r19, r1, 8                         ; if n < 8
                bnez r19, end_summary                   ; then goto end_summary
                ld f24, 56(r18)
                slti r19, r1, 9                         ; if n < 9
                bnez r19, end_summary                   ; then goto end_summary
                ld f26, 64(r18)
                slti r19, r1, 10                        ; if n < 10
                bnez r19, end_summary                   ; then goto end_summary
                ld f28, 72(r18)
                slti r19, r1, 11                        ; if n < 11
                bnez r19, end_summary                   ; then goto end_summary
                ld f30, 80(r18)
        end_summary:        

        trap 6