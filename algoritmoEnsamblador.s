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

        ; i: row index (i)
        ; j: column index (j)

        ; sum: temp result cell value (sum)
        ; mult: temp result cell value (mult)
        
        ; elementA: temp value MATRIZ_A[i][j] (elementA)
        ; elementX: temp value VECTOR_X[j] (elementX)

        ; offsetRowElementsA: offset calculation A (offsetRowElementsA)
        ; offsetElementsA: offset calculation A (offsetElementsA)
        ; offsetA: offset calculation A (offsetA)
        ; addressElementA: offset calculation A (addressElementA)
        
        ; offsetX: offset calculation X (offsetX)
        ; addressElementX: offset calculation X (addressElementX)
        
        ; temp: temp variable for jumps and such (temp)

        setup_loop_i:
                addi i, r0, 0                                           ; i = 0
        start_loop_i:
                slti temp, i, N                                         ; if i < N
                beqz temp, end_loop_i                                   ; then goto end_loop_i
                nop
        body_loop_i:

                ; Initialize variables 
                addi sum, r0, 0                                         ; sum = 0

                setup_loop_j:
                        addi j, r0, 0                                   ; j = 0
                start_loop_j:
                        slti temp, j, N                                 ; if j < N
                        beqz temp, end_loop_j                           ; then goto end_loop_j
                        nop
                body_loop_j:

                        ; Fetch MATRIZ_A[i][j]
                        mult offsetRowElementsA, i, N                   ; offsetRowElementsA = i * N
                        add offsetElementsA, offsetRowElementsA, j      ; offsetElementsA = offsetRowElementsA + j                              
                        mult offsetA, offsetElementsA, size             ; offsetA = offsetElementsA * size
                        add addressElementA, addressA, offsetA          ; addressElementA = addressA + offsetA
                        lw elementA, 0(addressElementA)                 ; elementA = *addressElementA
                        
                        ; Fetch VECTOR_X[j]                         
                        mult offsetX, j, size                           ; offsetX = j * size
                        add addressElementX, addressX, offsetX          ; addressElementX = addressX + offsetX
                        lw elementX, 0(addressElementX)                 ; elementX = *addressElementX

                        ; Calculate mult value
                        mult mult, elementA, elementX                   ; mult = elementA * elementX
                        
                        ; Update sum value
                        add sum, sum, mult                              ; sum = sum + mult

                tail_loop_j:
                        addi j, j, 1                                    ; j++
                        j start_loop_j                                  ; goto start_loop_j
                        nop
                end_loop_j:
                
                // Store sum in RESULTADO_B[i]
                mult offsetB, j, size                                   ; offsetB = i * size
                add addressElementB, addressB, offsetB                  ; addressElementB = addressB + offsetB
                sw 0(addressElementX), sum                              ; *addressElementB = sum
                
        tail_loop_i:
                addi i, i, 1                                            ; i++
                j start_loop_i
                nop
        end_loop_i:

