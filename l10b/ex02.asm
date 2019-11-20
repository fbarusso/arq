.data
Ent0: .asciiz "Informe o arquivo: "
ArquivoEnt: .space 32
ArquivoSai: .asciiz "saida.txt"
Buffer: .asciiz " "
Erro: .asciiz "Arquivo nao encontrado!\n"

.text
main:
    la $a0, Ent0 # Carrega o endereco da string
    li $v0, 4 # Codigo de impressao de string
    syscall # Imprime a string
    la $a0, ArquivoEnt # Endereco da string
    li $a1, 31 # Numero maximo de caracteres
    li $v0, 8 # Codigo de leitura de String
    syscall # Le o nome do arquivo
    jal removenovalinha # Remove \n do final
    li $a1, 0 # Modo leitura
    jal abertura
    move $s0, $v0 # Armazena o file descriptor
    la $a0, ArquivoSai # Nome do arquivo de saida
    li $a1, 1 # Modo escrita
    jal abertura
    move $s1, $v0 # Armazena o file descriptor
    jal varredura
    li $v0, 10 # Codigo de saida do programa
    syscall # Sai do programa
    
removenovalinha:
    li $t2, 0 # n = 0
    move $t0, $a0 # end = &string[0]
rm_loop:
    lb $t1, ($t0) # ch = string[i]
    bne $t1, '\n', rm_prox # if (ch != '\n') goto rm_prox
    li $t1, '\0' # ch = '\0'
    sb $t1, ($t0) # string[i] = ch
    jr $ra # Retorna
rm_prox:
    addi $t2, $t2, 1 # n++
    addi $t0, $t0, 1 # i++
    blt $t2, 32, rm_loop # if (n < 32) goto rm_loop
    jr $ra # Retorna

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


varredura:
    li $t1, '*' # estrela = '*'
    la $a1, Buffer # Buffer onde sera armazenado o caractere
    li $a2, 1 # Numero maximo de caracteres
varredura_loop:
    move $a0, $s0 # File descriptor
    li $v0, 14 # Codigo de leitura em arquivo
    syscall # Le do arquivo
    blez $v0, varredura_fim # Chegou ao fim do arquivo
    lb $t0, ($a1) # Carrega o caractere do buffer
    beq $t0, 'a', vogal
    beq $t0, 'A', vogal
    beq $t0, 'e', vogal
    beq $t0, 'E', vogal
    beq $t0, 'i', vogal
    beq $t0, 'I', vogal
    beq $t0, 'o', vogal
    beq $t0, 'O', vogal
    beq $t0, 'u', vogal
    beq $t0, 'U', vogal
    j varredura_escrita
vogal:
    sb $t1, ($a1) # Substitui o caractere no buffer por estrela
varredura_escrita:
    move $a0, $s1 # File descriptor (saida)
    li $v0, 15 # Codigo de escrita em arquivo
    syscall # Escreve no arquivo
    j varredura_loop
varredura_fim:
    jr $ra