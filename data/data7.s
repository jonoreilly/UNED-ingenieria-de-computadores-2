.data

        ; vector Nx1 (resultado esperado: 301,511,721,931,1141,1351)
        RESULTADO_B: .space 56
        
        ; matriz NxN
        MATRIZ_A: .double 11,12,13,14,15,16,17
                  .double 21,22,23,24,25,26,27
                  .double 31,32,33,34,35,36,37
                  .double 41,42,43,44,45,46,47
                  .double 51,52,53,54,55,56,57
                  .double 61,62,63,64,65,66,67
                  .double 71,72,73,74,75,76,77
        
        ; vector Nx1 
        VECTOR_X: .double 1,2,3,4,5,6,7,8,9,10

        MATRIZ_C: .space 392
        
        ; valor 0
        CERO:     .double 0
        
        ; Tamanio de la matriz
        N:        .word 6