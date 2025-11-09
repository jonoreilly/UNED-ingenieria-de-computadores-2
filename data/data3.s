.data

        ; vector Nx1 (resultado esperado: 301,511,721,931,1141,1351)
        RESULTADO_B: .space 24
        
        ; matriz NxN
        MATRIZ_A: .double 11,12,13,21,22,23
                  .double 31,32,33
        
        ; vector Nx1 
        VECTOR_X: .double 1,2,3

        MATRIZ_C: .space 72
        
        ; valor 0
        CERO:     .double 0
        
        ; Tamanio de la matriz
        N:        .word 6