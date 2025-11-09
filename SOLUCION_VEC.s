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

        ; ceroW: valor 0
        ; ceroD: valor 0

        ; n: valor de N (n)
        ; tamanioElemento: tamanio de los elementos (tamanioElemento)
        ; tamanioFila: tamanio de una fila (tamanioFila)

        ; vectorX: valor del VECTOR_X (vectorX)
        ; filaA: valor de la fila i de A (filaA)
        ; filaC: valor de la fila i de C (filaC)
        ; vectorB: valor del vector resultado B (vectorB)
        ; columnaC: valor de la columna j de C (columnaC)

        ; i: indice de filas (i)
        ; j: indice de columnas (j)

        ; desplazamientoFilaI: desplazamiento de la direccion del primer elemento de la fila i respecto al inicio de la matriz (desplazamientoFilaI)
        ; direccionFilaA: direccion del primer elemento de la fila i de A (direccionFilaA)
        ; direccionFilaC: direccion del primer elemento de la fila i de C (direccionFilaC)
        ; desplazamientoColumnaC: desplazamiento del primer elemento de la columna j de la matriz C respecto al inicio de C (desplazamientoColumnaC)
        ; direccionColumnaC: direccion del primer elemento de la columna j de C (direccionColumnaC)
        ; direccionVectorB: direccion del primer elemento del vector resultado B (direccionVectorB)

        ; temp: variable provisional para saltos y comparaciones (temp)

        ; **** Inicializacion ****

        ; Inicializa cero 
        ld ceroD, CERO                                                     ; cero = 0

        ; Carga el valor de N
        lw n, N                                                        ; n = &N

        ; Inicializa el registro longitud de vectores
        movi2s vlr, n                                                   ; vlr = n

        ; Establece el tamanio de los elementos como de 8 bytes (.double)
        addi tamanioElemento, ceroW, 8                                  ; tamanioElemento = 8
        
        ; Calcula el tamanio de una fila
        mult tamanioFila, n, tamanioElemento                            ; tamanioFila = n * tamanioElemento 

        ; Carga el vector X
        lv vectorX, VECTOR_X                                            ; vectorX = &VECTOR_X
        
        ; **** Multiplica las filas de A por el vector X ****

        setup_loop_i:
                addi i, ceroW, 0                                         ; i = 0
        start_loop_i:
                sge temp, i, n                                          ; if i >= n
                bnez temp, end_loop_i                                   ; then goto end_loop_i
        body_loop_i:    

                ; Calcula el desplazamiento hasta la fila actual
                mult desplazamientoFilaI, i, tamanioFila                        ; desplazamientoFilaI = i * tamanioFila

                ; Carga la fila A[i]
                addi direccionFilaA, desplazamientoFilaI, MATRIZ_A              ; direccionFilaA = desplazamientoFilaI + *MATRIZ_A
                lv filaA, direccionFilaA                                ; filaA = &direccionFilaA
                
                ; Multiplica la fila A[i] y el vector X
                multv filaC, vectorX, filaA                             ; filaC = vectorX *vec filaA      

                ; Almacena el resultado en C[i]       
                addi direccionFilaC, desplazamientoFilaI, MATRIZ_C              ; direccionFilaC = desplazamientoFilaI + *MATRIZ_C
                sv direccionFilaC, filaC                                ; *direccionFilaC = filaC
                
        tail_loop_i:
                addi i, i, 1                                            ; i++
                j start_loop_i
        end_loop_i:       

        ; **** Suma las multiplicaciones ****

        ; Inicializa el vector resultado B a todo ceros
        multsv vectorB, ceroD, vectorB                                   ; vectorB = [0,0...]

        setup_loop_j:
                addi j, ceroW, 0                                         ; j = 0
        start_loop_j:
                sge temp, j, n                                          ; if j >= n
                bnez temp, end_loop_j                                   ; then goto end_loop_j
        body_loop_j:

                ; Carga la columna C[][j]
                mult desplazamientoColumnaC, j, tamanioElemento                  ; desplazamientoColumnaC = j * tamanioElemento 
                addi direccionColumnaC, desplazamientoColumnaC, MATRIZ_C          ; direccionColumnaC = desplazamientoColumnaC + *MATRIZ_C 
                lvws columnaC, direccionColumnaC, tamanioFila            ; columnaC = *direccionColumnaC con tamanioFila entre cada elemento

                ; Suma la columna C[][j] al vector resultado B
                addv vectorB, vectorB, columnaC                         ; vectorB += columnaC
                
        tail_loop_j:
                addi j, j, 1                                            ; j++
                j start_loop_j
        end_loop_j:  

        ; Almacena el vector resultado en B
        addi direccionVectorB, ceroW, MATRIZ_B                           ; direccionVectorB = *MATRIZ_B
        sv direccionVectorB, vectorB                                    ; *direccionVectorB = vectorB

        trap 6