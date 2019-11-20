.data
inicial: .asciiz "Insira a ordem da matriz: "
insira: .asciiz "Insira o valor ["
insira2: .asciiz "]["
insira3: .asciiz "]: "
res: .asciiz "\nMatriz do Tipo ["

.align 2
resultado: .space 32

.text
main: jal solicitaOrdemMatriz #Salva a ordem da matriz em $s0
      jal processaMatriz
      jal printResultado
      li $v0, 10
      syscall
      
solicitaOrdemMatriz: la $a0, inicial
                     li $v0, 4
                     syscall
                     li $v0, 5
                     syscall
                     move $s0, $v0
                     jr $ra
                                     
processaMatriz: addiu $sp, $sp, -4
                sw $ra, ($sp)
               
                la $s1, resultado #Carrega a matriz de resultados em s1
                
                li $t0, 0   #t0 = i;
                li $t1, 0   #t1 = j;      
                
processaMatrizLoop: jal leituraFloat

		    sub $t3, $s0, $t0
                    sub $t3, $t3, 1  #Deixa pré-calculo em T3 o valor de n-i-1
                    
                    jal tipo1
                    jal tipo2
                    jal tipo3
                    jal tipo4
                    jal tipo5
                    jal tipo6
                    jal tipo7
                    jal tipo8
                    
                    add $t1, $t1, 1
                    blt $t1, $s0, processaMatrizLoop
                    
                    li $t1, 0
                    add $t0, $t0, 1
                    blt $t0, $s0, processaMatrizLoop         
                
processaMatrizFim: lw $ra, ($sp)
                   addiu $sp, $sp, 4
                   jr $ra
                   
printResultado: li $t0, 0 #Contador i = 0

printResultadoLoop: bge $t0, 8, back #Itera pelo array com 8 resultados
                    la $a0, res
                    li $v0, 4
                    syscall
                    move $a0, $t0
                    add $a0, $a0, 1
                    li $v0, 1
                    syscall
                    la $a0, insira3
                    li $v0, 4
                    syscall
                    sll $t1, $t0, 2
                    add $t1, $t1, $s1
                    l.s $f12, ($t1)
                    li $v0, 2
                    syscall
                    add $t0, $t0, 1
                    j printResultadoLoop
                   
leituraFloat: la $a0, insira
              li $v0, 4
              syscall
              move $a0, $t0
              li $v0, 1
              syscall
              la $a0, insira2
              li $v0, 4
              syscall
              move $a0, $t1
              li $v0, 1
              syscall
              la $a0, insira3
              li $v0, 4
              syscall
              li $v0, 6
              syscall
              jr $ra
                          
tipo1: ble $t1, $t0, back #if j > i
       add $t2, $s1, 0 
       j executaSoma
       
tipo2: bge $t1, $t3, back #if j < n-1-i
       add $t2, $s1, 4
       j executaSoma
       
tipo3: bge $t1, $t3, back #if  j < n-1-i &&
       ble $t1, $t0, back # // j > i
       add $t2, $s1, 8
       j executaSoma
       
tipo4: bge $t1, $t3, back #if  j < n-1-i &&
       bge $t1, $t0, back # // j < i
       add $t2, $s1, 12
       j executaSoma
       
tipo5: j tipo51
       
tipo51: bge $t1, $t3, tipo52 #if  j < n-1-i &&
        bge $t1, $t0, tipo52 # // j < i || (tipo52)
        add $t2, $s1, 16
        j executaSoma

tipo52: ble $t1, $t3, back #if  j > n-1-i &&
        ble $t1, $t0, back # // j > i
        add $t2, $s1, 16
        j executaSoma
       
tipo6: j tipo61

tipo61: bge $t1, $t3, tipo62 #if  j < n-1-i &&
        ble $t1, $t0, tipo62 # // j > i || (tipo62)
        add $t2, $s1, 20
        j executaSoma
        
tipo62: ble $t1, $t3, back #if  j > n-1-i &&
        bge $t1, $t0, back # // j < i 
        add $t2, $s1, 20
        j executaSoma
        
tipo7: j tipo71

tipo71: bge $t1, $t3, tipo72 #if  j < n-1-i &&
        bge $t1, $t0, tipo72 # // j < i || (tipo72)
        add $t2, $s1, 24
        j executaSoma
        
tipo72: bge $t1, $t3, back #if  j < n-1-i &&
        ble $t1, $t0, back # // j > i 
        add $t2, $s1, 24
        j executaSoma
        
tipo8: j tipo81

tipo81: bge $t1, $t3, tipo82 #if  j < n-1-i &&
        bge $t1, $t0, tipo82 # // j < i || (tipo72)
        add $t2, $s1, 28
        j executaSoma
        
tipo82: ble $t1, $t3, back #if  j > n-1-i &&
        bge $t1, $t0, back # // j < i 
        add $t2, $s1, 28
        j executaSoma
      
executaSoma: l.s $f1, ($t2) #Carrega o endereço de t2 em f1
             add.s $f1, $f1, $f0  #Soma com o valor atual
             s.s $f1, ($t2)  #Devolve o valor em t2
             j back
       
       

back: jr $ra
