.data
entradaN: .asciiz "Insira o numero de posicoes do vetor: "
entradaVet: .asciiz "Insira vet["
entradaAux: .asciiz "]: "
saida: .asciiz "O valor "
saida1: .asciiz " aparece "
saida2: .asciiz " vez(es)!\n"

.text

#variáveis
#	$s0 = tamanho do vetor
#	$s1 = endereço base do vetor
#	$s7 = null

li $s7, 0xFFFFFFF

main:
	jal n
	move $s0, $v0		#Salva em $s0 o valor lido
	
	move $a0, $s0		#Passa o tamanho do vetor para o argumento $a0
	jal alloc
	move $s1, $v0 		#Salva o endereço base do vetor retornado da função alloc em $s1
	
	move $a0, $s1		#Passa o endereço base do vetor para o argumento $a0
	move $a1, $s0		#Passa o tamanho do vetor para o argumento $a1
	jal scanVet
	
	move $a0, $s1		#Passa o endereco base do vetor para o parametro
	move $a1, $s0		#Passa o tamanho do vetor para o parametro
	jal frequency
	
	j exit
	 
n:
	la $a0, entradaN
	li $v0, 4		#Código de impressão de string
	syscall
	
	li $v0, 5		#Código de leitura de inteiro
	syscall
	
	jr $ra
	
alloc:
	mul $a0, $a0, 4		#Multiplica o tamanho do vetor por 4 bits
	li $v0, 9		#Código de alocação dinâmica
	syscall
	
	jr $ra

scanVet:
	move $t0, $a0		#Salva o endereço base do vetor em $t0
	move $t1, $t0		#Salva o endereço base do vetor em $t1 ($t1 será incrementado)
	li $t2, 0		#$t2 recebe 0 (contador de verificação)
	move $t3, $a1		#Salva o tamanho do vetor em $t3
	
l:	la $a0, entradaVet	
	li $v0, 4		#Código de impressão de string
	syscall
	
	move $a0, $t2
	li $v0, 1		#Código de impressão de inteiro
	syscall
	
	la $a0, entradaAux
	li $v0 4		#Código de impressão de string
	syscall
	
	li $v0, 5		#Código de leitura de inteiro
	syscall
	
	sw $v0, ($t1)		#Salva o valor lido no endereço armazenado em $t1
	addi $t1, $t1, 4	#Incrementa o endereço do vetor
	addi $t2, $t2, 1	#Incrementa o contador
	
	blt $t2, $t3, l		#Pula para l se o contador for menor que o tamanho do vetor
	
	jr $ra
	
frequency:
	move $t0, $a0		#$t0 recebe o endereco base do vetor
	move $t1, $t0		##t1 recebe o endereco base do vetor (sera incrementado)
	move $t2, $a1		#$t2 recebe o tamanho do vetor
	li $t3, 0		#Reseta o contador
	
l1:	mul $t1, $t3, 4
	add $t1, $t1, $t0	#Endereco da posicao I do vetor
	lw $t4, ($t1)		#Armazena em $t4 o valor armazenado na posicao $t1
	beq $t4, $s7, eIf	#Pula caso o valor seja igual ao define null
	
	li $t5, 0		#Reseta o contador de frequencia
	move $t6, $t0		#Passa o endereco base do vetor para &t6 (outro registrador para percorrer o vetor)
	li $t7, 0		#Reseta o segundo contador
	
l2:	mul $t6, $t7, 4
	add $t6, $t6, $t0
	lw $t8, ($t6)		#Armazena em $t8 o valor do segundo vetor percorrido
	
	bne $t4 $t8, eIf2
	addi $t5, $t5, 1	#Incrementa o contador de frequencia
	sw $s7, ($t6)		#Seta o valor do vetor como null para nao encontra-lo novamente
	
eIf2:	addi $t7, $t7, 1	#Incrementa o contador
	blt $t7, $t2, l2
	
	la $a0, saida
	li $v0, 4
	syscall
	
	move $a0, $t4
	li $v0, 1
	syscall
	
	la $a0, saida1
	li $v0, 4
	syscall
	
	move $a0, $t5
	li $v0, 1
	syscall
	
	la $a0, saida2
	li $v0, 4
	syscall
	
eIf:	addi $t3, $t3, 1	#Incrementa o contador
	blt $t3, $t2, l1	#Faz o loop enquanto o contador for menor que o tamanho maximo do vetor
	
	jr $ra

exit:
	li $v0, 10
	syscall
