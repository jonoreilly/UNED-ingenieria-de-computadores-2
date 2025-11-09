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

        ; cero: valor 0
        ; f0: valor 0

        ; n: valor de N (n)
        ; r2: tamanio de los elementos (tamanioElemento)

        ; i: indice de filas (i)
        ; r4: indice de columnas (j)

        ; f2: resultado de la suma de las multiplicaciones (suma)
        ; f4: resultado de la multiplicacion entre elementos de A y X (mult)
        
        ; f6: valor del elemento MATRIZ_A[i][j] (elementoA)
        ; f8: valor del elemento VECTOR_X[j] (elementoX)

        ; r5: elementos de las i filas de A (elementosFilasA)
        ; r6: posicion del elemento i,j de A (posicionElementoA)
        ; r7: offset de la direccion del elemento i,j de A respecto al inicio de A (offsetElementoA)
        ; r8: direccion del elemento i,j de A (direccionElementoA)
        
        ; r9: offset de la direccion del elemento j de X respecto al inicio de X (offsetElementoX)
        ; r10: direccion del elemento j de X (direccionElementoX)
        
        ; r11: offset de la direccion del elemento i de B respecto al inicio de B (offsetElementoB)
        ; r12: direccion del elemento i de B (direccionElementoB)
        
        ; temp: variable provisional para saltos y comparaciones (temp)


        ; **** Inicializacion ****

        ; Inicializa cero 
        ld f0, CERO                                                     ; cero = 0

        ; Carga el valor de N
        lw r1, N                                                        ; n = &N

        ; Carga el vector X
        lv vectorX, VECTOR_X                                            ; vectorX = &VECTOR_X
        
        ; Calcula el tamanio de una fila
        mult tamanioFila, n, tamanioElemento                            ; tamanioFila = n * tamanioElemento 

        ; Inicializa el registro longitud de vectores
        movi2s vlr, n                                                   ; vlr = n

        ; **** Multiplica las filas de A por el vector X ****

        setup_loop_i:
                addi i, cero, 0                                         ; i = 0
        start_loop_i:
                sge temp, i, n                                          ; if i >= n
                bnez temp, end_loop_i                                   ; then goto end_loop_i
        body_loop_i:    

                ; Calcula el desplazamiento hasta la fila actual
                mult offsetFilaI, i, tamanioFila                        ; offsetFilaI = i * tamanioFila

                ; Carga la fila A[i]
                addi direccionFilaA, offsetFilaI, MATRIZ_A              ; direccionFilaA = offsetFilaI + *MATRIZ_A
                lv filaA, direccionFilaA                                ; filaA = &direccionFilaA
                
                ; Multiplica la fila A[i] y el vector X
                multv filaC, vectorX, filaA                             ; filaC = vectorX *vec filaA      

                ; Almacena el resultado en C[i]       
                addi direccionFilaC, offsetFilaI, MATRIZ_C              ; direccionFilaC = offsetFilaI + *MATRIZ_C
                sv direccionFilaC, filaC                                ; *direccionFilaC = filaC
                
        tail_loop_i:
                addi i, i, 1                                            ; i++
                j start_loop_i
        end_loop_i:       

        ; **** Suma las multiplicaciones ****

        ; Inicializa el vector resultado B a todo ceros
        multsv vectorB, cero, vectorB                                   ; vectorB = [0,0...]

        setup_loop_j:
                addi j, cero, 0                                         ; j = 0
        start_loop_j:
                sge temp, j, n                                          ; if j >= n
                bnez temp, end_loop_j                                   ; then goto end_loop_j
        body_loop_j:

                ; Carga la columna C[][j]
                mult offsetColumna, j, tamanioElemento                  ; offsetColumna = j * tamanioElemento 
                addi direccionColumna, offsetColumna, MATRIZ_C          ; direccionColumna = offsetColumna + *MATRIZ_C 
                lvws columnaC, direccionColumna, tamanioFila            ; columnaC = *direccionColumna con tamanioFila entre cada elemento

                ; Suma la columna C[][j] al vector resultado B
                addv vectorB, vectorB, columnaC                         ; vectorB += columnaC
                
        tail_loop_j:
                addi j, j, 1                                            ; j++
                j start_loop_j
        end_loop_j:  

        ; Almacena el vector resultado en B
        addi direccionVectorB, cero, MATRIZ_B                           ; direccionVectorB = *MATRIZ_B
        sv direccionVectorB, vectorB                                    ; *direccionVectorB = vectorB

        trap 6