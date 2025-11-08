.data
        A: .double 11,12,13,21,22,23,31,33,33
        x: .double 1,2,3
        b: .space 24
        n: .word 3
        
.text

        ; r1: row index (i)
        ; r2: column index (j)
        ; r3: inner index (k)
        ; r4: address of matrizA
        ; r5: address of matrizB
        ; r6: address of result
        ; r7: temp value from matrizA
        ; r8: temp value from matrizB
        ; r9: accumulator (sum)
        ; r10: offset calculation

        setup_loop_i:
                addi r1, r0, 0                                  ; i = 0
        start_loop_i:
                slti r11, r1, M                                 ; if i < M
                beqz r11, end_loop_i                            ; then goto end_loop_i
                nop

                setup_loop_j:
                        addi r2, r0, 0                          ; j = 0
                start_loop_j:
                        slti r12, r2, P                         ; if j < P
                        beqz r12, end_loop_j                    ; then goto end_loop_j
                        nop

                        addi r9, r0, 0                          ; sum = 0

                        setup_loop_k:
                                addi r3, r0, 0                  ; k = 0
                        start_loop_k:
                                slti r13, r3, N                 ; if k < N
                                beqz r13, end_loop_k            ; then goto end_loop_k
                                nop

                                ; Calculate matrizA[i][k] address
                                sll r10, r1, log2(N*4)          ; i*N*4
                                sll r14, r3, 2                  ; k*4
                                add r10, r10, r14               ; offset
                                add r10, r4, r10                ; base + offset
                                lw r7, 0(r10)                   ; load matrizA[i][k]

                                ; Calculate matrizB[k][j] address
                                sll r15, r3, log2(P*4)          ; k*P*4
                                sll r16, r2, 2                  ; j*4
                                add r15, r15, r16               ; offset
                                add r15, r5, r15                ; base + offset
                                lw r8, 0(r15)                   ; load matrizB[k][j]
                                mult r17, r7, r8                ; temp = matrizA[i][k] * matrizB[k][j]
                                add r9, r9, r17                 ; sum += temp
                                addi r3, r3, 1                  ; k++
                                j start_loop_k                  ; goto start_loop_k
                                nop
                        end_loop_k:
                        
                        // Store result[i][j]
                        sll r18, r1, log2(P*4)                  ; i*P*4
                        sll r19, r2, 2                          ; j*4
                        add r18, r18, r19                       ; offset
                        add r18, r6, r18                        ; base + offset
                        sw 0(r18), r9                           ; result[i][j] = sum
                        addi r2, r2, 1                          ; j++
                        j start_loop_j                          ; goto start_loop_j
                        nop
                end_loop_j:

                addi r1, r1, 1                                  ; i++
                j start_loop_i
                nop
        end_loop_i:

