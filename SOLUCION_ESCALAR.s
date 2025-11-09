.data

        ; vector Nx1 (resultado esperado: 301,511,721,931,1141,1351)
        RESULTADO_B: .space 48
        
        ; matriz NxN
        MATRIZ_A: .double 11,12,13,14,15,16,21,22,23,24,25,26
                  .double 31,32,33,34,35,36,41,42,43,44,45,46
                  .double 51,52,53,54,55,56,61,62,63,64,65,66
        
        ; vector Nx1 
        VECTOR_X: .double 1,2,3,4,5,6
        
        ; valor 0
        CERO: .double 0
        
        ; Tamanio de la matriz
        N: .word 6
        
.text

        ; r0: valor 0
        ; f0: valor 0

        ; r1: valor de N (n)
        ; r2: tamanio de los elementos (tamanioElemento)

        ; r3: indice de filas (i)
        ; r4: indice de columnas (j)

        ; f2: resultado de la suma de las multiplicaciones (suma)
        ; f4: resultado de la multiplicacion entre elementos de A y X (mult)
        
        ; f6: valor del elemento MATRIZ_A[i][j] (elementoA)
        ; f8: valor del elemento VECTOR_X[j] (elementoX)

        ; r5: elementos de las i filas de A (elementosFilasA)
        ; r6: posicion del elemento i,j de A (posicionElementoA)
        ; r7: desplazamiento de la direccion del elemento i,j de A respecto al inicio de A (desplazamientoElementoA)
        ; r8: direccion del elemento i,j de A (direccionElementoA)
        
        ; r9: desplazamiento de la direccion del elemento j de X respecto al inicio de X (desplazamientoElementoX)
        ; r10: direccion del elemento j de X (direccionElementoX)
        
        ; r11: desplazamiento de la direccion del elemento i de B respecto al inicio de B (desplazamientoElementoB)
        ; r12: direccion del elemento i de B (direccionElementoB)
        
        ; r13: variable provisional para saltos y comparaciones (temp)
        
        ; **** Inicializacion ****

        ; Inicializa cero 
        ld f0, CERO                                     ; cero = 0

        ; Carga el valor de N
        lw r1, N                                        ; n = &N

        ; Establece el tamanio de los elementos como de 8 bytes (.double)
        addi r2, r0, 8                                  ; tamanioElemento = 8

        ; **** Multiplica la matriz y el vector ****

        setup_loop_i:
                addi r3, r0, 0                          ; i = 0
        start_loop_i:
                sge r13, r3, r1                         ; if i >= n
                bnez r13, end_loop_i                    ; then goto end_loop_i
        body_loop_i:

                ; Inicializa la variable suma  
                addd f2, f0, f0                         ; suma = 0

                setup_loop_j:
                        addi r4, r0, 0                  ; j = 0
                start_loop_j:
                        sge r13, r4, r1                 ; if j >= n
                        bnez r13, end_loop_j            ; then goto end_loop_j
                body_loop_j:

                        ; Carga el elemento MATRIZ_A[i][j]
                        mult r5, r3, r1                 ; elementosFilasA = i * n
                        add r6, r5, r4                  ; posicionElementoA = elementosFilasA + j                              
                        mult r7, r6, r2                 ; desplazamientoElementoA = posicionElementoA * tamanioElemento
                        addi r8, r7, MATRIZ_A           ; direccionElementoA = desplazamientoElementoA + *MATRIZ_A
                        ld f6, 0(r8)                    ; elementoA = &direccionElementoA
                        
                        ; Carga el elemento VECTOR_X[j]                         
                        mult r9, r4, r2                 ; desplazamientoElementoX = j * tamanioElemento
                        addi r10, r9, VECTOR_X          ; direccionElementoX = desplazamientoElementoX + *VECTOR_X
                        ld f8, 0(r10)                   ; elementoX = &direccionElementoX

                        ; Calcula la multiplicacion
                        multd f4, f6, f8                ; mult = elementoA * elementoX
                        
                        ; Se lo anade a la suma
                        addd f2, f2, f4                 ; suma += mult

                tail_loop_j:
                        addi r4, r4, 1                  ; j++
                        j start_loop_j                  ; goto start_loop_j
                end_loop_j:
                
                ; Guarda la suma en RESULTADO_B[i]
                mult r11, r3, r2                        ; desplazamientoElementoB = i * tamanioElemento
                addi r12, r11, RESULTADO_B              ; direccionElementoB = desplazamientoElementoB + *RESULTADO_B
                sd 0(r12), f2                           ; *direccionElementoB = suma
                
        tail_loop_i:
                addi r3, r3, 1                          ; i++
                j start_loop_i
        end_loop_i:       

        trap 6