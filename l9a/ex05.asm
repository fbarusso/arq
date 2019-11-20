.data
Cpf: .space 32
Ent0: .asciiz "Informe o CPF: "
Sai0: .asciiz "CPF valido."
Sai1: .asciiz "CPF invalido."

.text
main:
    la $a0, Ent0 # Carrega o endereco da string
    li $v0, 4 # Codigo de impressao de string
    syscall # Imprime a string
    la $a0, Cpf # Endereco da string lida
    li $a1, 32 # Tamanho maximo da string
    li $v0, 8 # Codigo de leitura de string
    syscall # Le a string
    jal validacao
    li $v0, 10 # Codigo de saida do programa
    syscall # Sai do programa
    
validacao:
    li $t0, 0 # i = 0
    move $t1, $a0 # end = &string[0]
    li $t8, 10 # dez = 10
    li $t9, 11 # onze = 11
validacao_loop:
    lb $t4, ($t1) # c = string[i]
if1:
    bge $t0, 9, if2 # if (i >= 9) goto if2
    subi $t5, $t4, '0' # num = c - '0' (converte char para int)
    sub $t6, $t8, $t0 # mult = 10 - i
    mul $t7, $t5, $t6 # num * mult
    add $t2, $t2, $t7 # soma1 += num * mult
    addi $t6, $t6, 1 # mult++
    mul $t7, $t5, $t6 # num * mult
    add $t3, $t3, $t7 # soma2 += num * mult
    j validacao_prox
if2:
    bne $t0, 9, if3 # if (i != 9) goto if3
    bne $t4, '-', validacao_falsa
    j validacao_prox
if3:
    bne $t0, 10, if4 # if (i != 10) goto if4
    div $t2, $t9 # soma1 / onze
    mfhi $t5 # resto = soma1 % onze
    if3_1:
        bge $t5, 2, if3_2 # if (resto >= 2) goto if3_2
        li $s0, '0' # digito1 = '0'
        j if3_3
    if3_2:
        sub $s0, $t9, $t5 # digito1 = 11 - resto
        sll $t5, $s0, 1 # d1 * 2
        add $t3, $t3, $t5 # soma2 += d1 * 2
        addi $s0, $s0, '0' # digito1 += '0' (converte int para char)
    if3_3:
        bne $s0, $t4, validacao_falsa # if (digito1 != string[i]) goto validacao_falsa
        j validacao_prox
if4:
    bne $t0, 11, if5 # if (i != 11) goto if5
    div $t3, $t9 # soma2 / onze
    mfhi $t5 # resto = soma2 % onze
    if4_1:
        bge $t5, 2, if4_2 # if (resto >= 2) goto if4_2
        li $s1, '0' # digito2 = '0'
        j if4_3
    if4_2:
        sub $s1, $t9, $t5 # digito2 = 11 - resto
        addi $s1, $s1, '0' # digito2 += '0' (converte int para char)
    if4_3:
        bne $s1, $t4, validacao_falsa # if (digito2 != string[i]) goto validacao_falsa
        j validacao_prox
if5:
    bne $t4, '\n', validacao_falsa # if (string[i] != '\n') goto validacao_falsa
    j validacao_verdadeira
validacao_prox:
    addi $t0, $t0, 1 # i++
    addi $t1, $t1, 1 # end++
    bnez $t4, validacao_loop
validacao_falsa:
    la $a0, Sai1 # Carrega o endereco da string
    li $v0, 4 # Codigo de impressao de string
    syscall # Imprime a string
    jr $ra # Retorna para a main
validacao_verdadeira:
    la $a0, Sai0 # Carrega o endereco da string
    li $v0, 4 # Codigo de impressao de string
    syscall # Imprime a string
    jr $ra # Retorna para a main

