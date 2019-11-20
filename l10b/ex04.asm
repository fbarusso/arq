.data
ArquivoEnt: .asciiz "matriz.txt"
ArquivoSai: .asciiz "matriz saida.txt"
Buffer: .asciiz " "
Erro: .asciiz "Arquivo nao encontrado!\n"
Zero: .asciiz "0 "
Um: .asciiz "1 "
Newline: .asciiz "\r\n"

.text
main:
    la $a0, ArquivoEnt # Nome do arquivo de entrada
    li $a1, 0 # Modo leitura
    jal abertura
    move $s0, $v0 # Armazena o file descriptor
    la $a0, ArquivoSai # Nome do arquivo de saida
    li $a1, 1 # Modo escrita
    jal abertura
    move $s1, $v0 # Armazena o file descriptor
    jal leitura
    jal escrita
    li $v0, 10
    syscall

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

lernumero:
    li $t1, 0
    li $t2, 0
ln_loop:
    la $a1, Buffer # Buffer de leitura
    li $a2, 1 # Ler 1 caractere
    li $v0, 14 # Codigo de leitura em arquivo
    syscall # Le do arquivo
    blez $v0, ln_fim # Retorna se chegou ao fim do arquivo
    lb $t0, ($a1) # Carrega o caractere lido
    blt $t0, '0', ln_naonum
    bgt $t0, '9', ln_naonum
    j ln_num
ln_naonum:
    bgt $t1, 0, ln_fim
    j ln_loop
ln_num:
    subi $t0, $t0, '0' # Converte caractere para numero
    addi $t1, $t1, 1 # digitos++
    mul $t2, $t2, 10 # num *= 10
    add $t2, $t2, $t0 # num += algarismo
    j ln_loop
ln_fim:
    move $v0, $t2 # Retornar num
    jr $ra # Retorno
    
leitura:
    subi $sp, $sp, 4 # Libera espaco para 1 item na pilha
    sw $ra, ($sp) # Armazena endereco de retorno
    move $a0, $s0 # File descriptor
    jal lernumero # Ler linhas da matriz
    move $s3, $v0 # linhas
    jal lernumero # Ler colunas da matriz
    move $s4, $v0 # colunas
    mul $a0, $s3, $s4 # tamanho = linhas * colunas
    li $v0, 9 # Codigo de alocacao dinamica
    syscall # Aloca a matriz
    move $s2, $v0 # matriz
    move $a0, $s0 # File descriptor
    jal lernumero # Ler nposicoes
    move $t5, $v0 # nposicoes
    li $t0, 0 # i = 0
leitura_loop:
    bge $t0, $t5, leitura_fim # if (i >= nposicoes) goto leitura_fim
    subi $sp, $sp, 4 # Libera espaco para 1 item na pilha
    sw $t0, ($sp) # Armazena i
    jal lernumero # Le a linha
    mul $t3, $v0, $s4 # end = colunas * linha
    jal lernumero # Le a coluna
    add $t3, $t3, $v0 # end += coluna
    add $t3, $t3, $s2 # end += endbase
    li $t4, 1 # um = 1
    sb $t4, ($t3) # matriz[linha][coluna] = um
    lw $t0, ($sp) # Recupera i
    addi $sp, $sp, 4 # Libera espaco para 1 item na pilha
    addi $t0, $t0, 1 # i++
    j leitura_loop
leitura_fim:
    li $v0, 16 # Codigo de fechamento de arquivo
    syscall # Fecha o arquivo
    lw $ra, ($sp) # Recupera endereco de retorno
    addi $sp, $sp, 4 # Libera espaco para 1 item na pilha
    jr $ra # Retorna
    
escrita:
    li $t0, 0 # i = 0
    li $t1, 0 # j = 0
    move $t2, $s2 # end = &matriz[0][0]
    move $a0, $s1 # File descriptor da saida
    li $a2, 2 # 2 caracteres
escrita_loop:
    lb $t3, ($t2) # anulado = matriz[i][j]
    beqz $t3, escrita_um # if (anulado == 0) goto escrita_um
    la $a1, Zero # Carrega a string Zero
    j escrita_escrever
escrita_um:
    la $a1, Um # Carrega a string Um
escrita_escrever:
    li $v0, 15 # Codigo de escrita em arquivo
    syscall # Escreve no arquivo
    addi $t2, $t2, 1 # end++
    addi $t1, $t1, 1 # j++
    blt $t1, $s4, escrita_loop # if (j < colunas) goto escrita_loop
    li $t1, 0 # j = 0
    la $a1, Newline # Carrega a string de nova linha
    li $v0, 15 # Codigo de escrita em arquivo
    syscall # Escreve nova linha no arquivo
    addi $t0, $t0, 1 # i++
    blt $t0, $s3, escrita_loop # if (i < linhas) goto escrita_loop
    li $v0, 16 # Codigo de fechamento de arquivo
    syscall # Fecha o arquivo
    jr $ra # Retorna
