.data
Ent0: .asciiz "Informe n: "
Arquivo: .asciiz "gemeos.txt"
Buffer: .asciiz " "
Erro: .asciiz "Arquivo nao encontrado!\n"

.text
main:
    la $a0, Arquivo # Carrega o nome do arquivo
    li $a1, 1 # Modo escrita
    jal abertura # Abre o arquivo
    move $s0, $v0 # Guarda o file descriptor
    la $a0, Ent0 # Carrega o endereco da string
    li $v0, 4 # Codigo de impressao de string
    syscall # Imprime a string
    li $v0, 5 # Codigo de leitura de inteiro
    syscall # Le o inteiro
    blt $v0, 3, fechamento # if (n < 3) goto fechamento
    subi $sp, $sp, 4 # Espaco para 1 item na pilha
    sw $v0, ($sp) # Armazena o inteiro lido na pilha
    move $a0, $v0 # n como parametro
    jal criva # Criva de Erastotenes
    move $a0, $v0 # Endereco do vetor
    lw $a1, ($sp) # n
    addi $sp, $sp, 4 # Libera espaco na pilha
    jal gemeos
fechamento:
    move $a0, $s0 # File descriptor
    li $v0, 16 # Codigo de fechamento de arquivo
    syscall # Fecha o arquivo
    li $v0, 10 # Codigo de saida do programa
    syscall # Sai do programa
    
abertura:
    li $v0, 13 # Codigo de leitura de arquivo
    syscall # Tenta abrir arquivo
    bgez $v0, a # if (file_descriptor >= 0) goto a
    la $a0, Erro # else erro: carrega o endereco da string
    li $v0, 4 # Codigo de impressao de string
    syscall # Imprime o erro
    li $v0, 10 # Codigo de saida do programa
    syscall # Finaliza o programa
a:  jr $ra # Retorna    
    
printnumero:
    move $a3, $a0 # Copia o numero
    move $a0, $a1 # File descriptor
    la $a1, Buffer # Buffer
    li $a2, 1 # 1 caractere apenas
    bnez $a3, pn_naozero # if (num != 0) goto pn_naozero
    li $v0, 15 # Codigo de escrita de caractere
    li $t0, '0' # Escrever caractere 0
    sb $t0, ($a1) # Armazenar no buffer de escrita
    syscall # Escrever no arquivo
    jr $ra # Retornar
pn_naozero:
    li $t0, 0 # digitos = 0
    li $t2, 10 # dez = 10
    bgtz $a3, pn_loop # if (num > 0) goto pn_loop
    li $t1, '-' # Escrever caractere -
    sb $t1, ($a1) # Armazenar no buffer de escrita
    li $v0, 15 # Codigo de escrita de caractere
    syscall # Escreve no arquivo
    mul $a3, $a3, -1 # num *= -1
pn_loop:
    subi $sp, $sp, 1 # Espaco para 1 caractere na pilha
    addi $t0, $t0, 1 # digitos++
    div $a3, $t2 # num / 10
    mfhi $t1 # char = num % 10
    addi $t1, $t1, '0' # char += '0'
    sb $t1, ($sp) # Guarda o caractere na pilha
    mflo $a3 # num /= 10
    bgtz $a3, pn_loop # if (num > 0) goto pn_loop
pn_print:
    lb $t1, ($sp) # Carrega o caractere da pilha
    sb $t1, ($a1) # Armazenar no buffer de escrita
    li $v0, 15 # Codigo de escrita de caractere
    syscall # Escreve no arquivo
    addi $sp, $sp, 1 # Libera um espaco na pilha
    subi $t0, $t0, 1 # digitos--
    bgtz $t0, pn_print # if (digitos > 0) goto pn_print
    li $t1, '\n' # Escrever nova linha
    sb $t1, ($a1) # Armazenar no buffer de escrita
    li $v0, 15 # Codigo de escrita de caractere
    syscall # Escreve no arquivo
    jr $ra # retorna
    
    
criva:
    move $a3, $a0 # Copia n
    addi $a0, $a0, 3 # n += 3
    sll $a0, $a0, 2 # n *= 4
    li $v0, 9 # Codigo de alocacao dinamica
    syscall # Aloca um vetor com n + 1 inteiros
    addi $a3, $a3, 2 # Calcular mais dois primos
    move $t2, $v0 # endereco
    li $t5, 1 # naoprimo
    sw $t5, ($t2) # vet[0] = 1
    sw $t5, 4($t2) # vet[1] = 1
    addi $t2, $t2, 8
    li $t0, 2 # p = 2
    mul $t1, $t0, $t0 # psquared = p * p
criva_loop:
    lw $t3, ($t2) # primo = primos[p]
    bnez $t3, criva_prox # if (primos[p] != 0) goto criva_prox
    move $t3, $t1 # i = psquared
criva_loop2:
    bgt $t3, $a3, criva_prox # if (i > n) goto criva_prox
    sll $t4, $t3, 2 # endi = i * 4
    add $t4, $t4, $v0 # endi += endbase
    sw $t5, ($t4) # primos[i] = 1
    add $t3, $t3, $t0 # i += p
    j criva_loop2
criva_prox:
    addi $t0, $t0, 1 # p++
    addi $t2, $t2, 4 # Proximo endereco
    mul $t1, $t0, $t0 # psquared = p * p
    ble $t1, $a3, criva_loop # if (psquared <= n) goto criva_loop
    jr $ra # retorna
    
    
gemeos:
    subi $sp, $sp, 4 # Espaco para 1 item na pilha
    sw $ra, ($sp) # Guarda endereco de retorno na pilha
    li $t0, 2 # i = 2
    addi $a0, $a0, 8
gemeos_loop:
    addi $t1, $t0, 2 # i + 2
    bgt $t0, $a1, gemeos_fim # if (i > n) goto gemeos_fim
    lw $t2, ($a0) # primo = primos[i]
    bnez $t2, gemeos_prox # if (primo != 0) goto gemeos_prox
    addi $t1, $a0, 8 # primos[i + 2]
    lw $t2, ($t1) # primo = primos[i + 2]
    bnez $t2, gemeos_prox # if (primo != 0) goto gemeos_prox
    subi $sp, $sp, 4 # Espaco para 1 item na pilha
    sw $a0, ($sp) # Guarda endereco do vetor na pilha
    subi $sp, $sp, 4 # Espaco para 1 item na pilha
    sw $a1, ($sp) # Guarda n na pilha
    subi $sp, $sp, 4 # Espaco para 1 item na pilha
    sw $t0, ($sp) # Guarda i na pilha
    move $a0, $t0 # Numero como argumento
    move $a1, $s0 # File descriptor como argumento
    jal printnumero # Escreve o numero no arquivo
    lw $t0, ($sp) # Recupera i da pilha
    addi $sp, $sp, 4 # Libera espaco na pilha
    lw $a1, ($sp) # Recupera n da pilha
    addi $sp, $sp, 4 # Libera espaco na pilha
    lw $a0, ($sp) # Recupera endereco do vetor da pilha
    addi $sp, $sp, 4 # Libera espaco na pilha
gemeos_prox:
    addi $t0, $t0, 1 # i++
    addi $a0, $a0, 4 # Proximo endereco do vetor
    j gemeos_loop
gemeos_fim:
    lw $ra, ($sp) # Recupera endereco de retorno da pilha
    addi $sp, $sp, 4 # Libera espaco na pilha
    jr $ra # Retorna