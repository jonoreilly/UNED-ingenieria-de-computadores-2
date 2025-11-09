.data

        ; vector Nx1 (resultado esperado: 735,1185,1635,2085,2535,2985,3435,3885,4335)
        RESULTADO_B: .space 72
        
        ; matriz NxN
        MATRIZ_A: .double 11,12,13,14,15,16,17,18,19
                  .double 21,22,23,24,25,26,27,28,29
                  .double 31,32,33,34,35,36,37,38,39
                  .double 41,42,43,44,45,46,47,48,49
                  .double 51,52,53,54,55,56,57,58,59
                  .double 61,62,63,64,65,66,67,68,69
                  .double 71,72,73,74,75,76,77,78,79
                  .double 81,82,83,84,85,86,87,88,89
                  .double 91,92,93,94,95,96,97,98,99
        
        ; vector Nx1 
        VECTOR_X: .double 1,2,3,4,5,6,7,8,9,10

        MATRIZ_C: .space 648
        
        ; valor 0
        CERO:     .double 0
        
        ; Tamanio de la matriz
        N:        .word 9