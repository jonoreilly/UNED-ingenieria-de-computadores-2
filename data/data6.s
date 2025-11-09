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
        CERO:     .double 0
        
        ; Tamanio de la matriz
        N:        .word 6