.data

        ; vector Nx1 (resultado esperado: 301,511,721,931,1141,1351)
        RESULTADO_B: .space 48
        
        ; matriz NxN
        MATRIZ_A: .double 11,12,13,14,15,16,21,22,23,24,25,26
                  .double 31,32,33,34,35,36,41,42,43,44,45,46
                  .double 51,52,53,54,55,56,61,62,63,64,65,66
        
        ; vector Nx1 
        VECTOR_X: .double 1,2,3,4,5,6

        MATRIZ_C: .space 288
        
        ; valor 0
        CERO: .double 0
        
        ; Size of matrix
        N: .word 6
        
.text

        ; r0: valor 0
        ; f0: valor 0

        ; r1: valor de N (n)
        ; r2: tamanio de los elementos (tamanioElemento)
        ; r3: tamanio de una fila (tamanioFila)

        ; v0: valor del VECTOR_X (vectorX)
        ; v1: valor de la fila i de A (filaA)
        ; v2: valor de la fila i de C (filaC)
        ; v3: valor del vector resultado B (vectorB)
        ; v4: valor de la columna j de C (columnaC)

        ; r4: indice de filas (i)
        ; r5: indice de columnas (j)

        ; r6: desplazamiento de la direccion del primer elemento de la fila i respecto al inicio de la matriz (desplazamientoFilaI)
        ; r7: direccion del primer elemento de la fila i de A (direccionFilaA)
        ; r8: direccion del primer elemento de la fila i de C (direccionFilaC)
        ; r9: desplazamiento del primer elemento de la columna j de la matriz C respecto al inicio de C (desplazamientoColumnaC)
        ; r10: direccion del primer elemento de la columna j de C (direccionColumnaC)
        ; r11: direccion del primer elemento del vector resultado B (direccionVectorB)

        ; r12: variable provisional para saltos y comparaciones (temp)

        ; **** Inicializacion ****

        ; Inicializa cero 
        ld f0, CERO                                     ; cero = 0

        ; Carga el valor de N
        lw r1, N                                        ; n = &N

        ; Inicializa el registro longitud de vectores
        movi2s vlr, r1                                  ; vlr = n

        ; Establece el tamanio de los elementos como de 8 bytes (.double)
        addi r2, r0, 8                                  ; tamanioElemento = 8
        
        ; Calcula el tamanio de una fila
        mult r3, r1, r2                                 ; tamanioFila = n * tamanioElemento 

        ; Carga el vector X
        lv v0, VECTOR_X                                 ; vectorX = &VECTOR_X
        
        ; **** Multiplica las filas de A por el vector X ****

        setup_loop_i:
                addi r4, r0, 0                          ; i = 0
        start_loop_i:
                sge r12, r4, r1                         ; if i >= n
                bnez r12, end_loop_i                    ; then goto end_loop_i
        body_loop_i:    

                ; Calcula el desplazamiento hasta la fila actual
                mult r6, r4, r3                         ; desplazamientoFilaI = i * tamanioFila

                ; Carga la fila A[i]
                addi r7, r6, MATRIZ_A                   ; direccionFilaA = desplazamientoFilaI + *MATRIZ_A
                lv v1, 0(r7)                            ; filaA = &direccionFilaA
                
                ; Multiplica la fila A[i] y el vector X
                multv v2, v0, v1                        ; filaC = vectorX *vec filaA      

                ; Almacena el resultado en C[i]       
                addi r8, r6, MATRIZ_C                   ; direccionFilaC = desplazamientoFilaI + *MATRIZ_C
                sv 0(r8), v2                            ; *direccionFilaC = filaC
                
        tail_loop_i:
                addi r4, r4, 1                          ; i++
                j start_loop_i
        end_loop_i:       

        ; **** Suma las multiplicaciones ****

        ; Inicializa el vector resultado B a todo ceros
        multsv v3, f0, v3                               ; vectorB = [0,0...]

        setup_loop_j:
                addi r5, r0, 0                          ; j = 0
        start_loop_j:
                sge r12, r5, r1                         ; if j >= n
                bnez r12, end_loop_j                    ; then goto end_loop_j
        body_loop_j:

                ; Carga la columna C[][j]
                mult r9, r5, r2                         ; desplazamientoColumnaC = j * tamanioElemento 
                addi r10, r9, MATRIZ_C                  ; direccionColumnaC = desplazamientoColumnaC + *MATRIZ_C 
                lvws v4, r10, r3                        ; columnaC = *direccionColumnaC con tamanioFila entre cada elemento

                ; Suma la columna C[][j] al vector resultado B
                addv v3, v3, v4                         ; vectorB += columnaC
                
        tail_loop_j:
                addi r5, r5, 1                          ; j++
                j start_loop_j
        end_loop_j:  

        ; Almacena el vector resultado en B
        addi r11, r0, RESULTADO_B                       ; direccionVectorB = *MATRIZ_B
        sv 0(r11), v3                                   ; *direccionVectorB = vectorB

        trap 6