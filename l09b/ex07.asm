.data

matriz: 	.space 36

entradaMatriz: 	.asciiz "Insira o valor de matriz["
entradaMatriz2: .asciiz "]["
entradaMatriz3: .asciiz "]: "

saida90:	.asciiz "Gira 90 graus:\n"
saida180:	.asciiz "Gira 180 graus:\n"
saida270:	.asciiz "Gira 270 graus:\n"

.text

main:		la $a0 matriz		# $a0 aponta para matriz
		li $a1 3		# $a1 recebe 3, numeroLinhas = 3
		li $a2 3		# $a2 recebe 3, numeroColunas = 3
		
		jal leitura		# leitura(matriz, numeroLinhas, numeroColunas), retorna matriz em $v0
		
		move $a0, $v0
		
		jal escrita90		# escrita90(matriz, numeroLinhas, numerosColunas), retorna matriz em $v0
		
		move $a0, $v0
		
		jal escrita180		# escrita180(matriz, numeroLinhas, numerosColunas), retorna matriz em $v0
		
		move $a0, $v0
		
		jal escrita270		# escrita270(matriz, numeroLinhas, numerosColunas), retorna matriz em $v0
		
		j saida			# finaliza o programa
		
indice:		mul $v0, $t0, $a2	# i * numeroColunas
		add $v0, $v0, $t1	# (i * numeroColunas) + j
		sll $v0, $v0, 2		# [(i * numeroColunas) + j] * 4 (inteiro)
		add $v0, $v0, $a3	# soma o endereço base de matriz
		jr $ra			# retorna para o caller
		
leitura:	subi $sp, $sp, 4	# espaço para 1 item na pilha
		sw $ra, ($sp)		# salva o retorno para a main
		move $a3, $a0		# aux = endereço base de matriz
	
l:		la $a0, entradaMatriz	# carrega o endereço da string
		li $v0, 4		# código de impressão de string
		syscall			# imprime a string
	
		move $a0, $t0		# valor de i para impressao
		li $v0, 1		# código de impressao de inteiro
		syscall			# imprime i
		
		la $a0, entradaMatriz2	# carrega o endereço da string
		li $v0, 4		# código de impressão de string
		syscall			# imprime a string
	
		move $a0, $t1		# valor de j para impressao
		li $v0, 1		# código de impressao de inteiro
		syscall			# imprime j
	
		la $a0, entradaMatriz3	# carrega o endereço da string
		li $v0, 4		# código de impressão de string
		syscall			# imprime a string
	
		li $v0, 5		# codigo de leitura de inteiro
		syscall			# leitura do valor (retorna em $v0)
	
		move $t2, $v0		# aux = valor lido
	
		jal indice		# calcula o endereço de matriz[i][j]
	
		sw $t2, ($v0)		# matriz[i][j] = aux
	
		addi $t1, $t1, 1	# j++
		blt $t1, $a2, l		# if (j < numeroColunas) goto l
		li $t1, 0		# j = 0
	
		addi $t0, $t0, 1	# i++
		blt $t0, $a1, l		# if (i < numeroLinhas) goto l
		li $t0, 0		# i = 0
	
		lw $ra, ($sp)		# recupera o retorno para a main
		addi $sp, $sp, 4	# libera o espaço na pilha
		move $v0, $a3		# endereço da matriz para retorno
		jr $ra			# retorna para o caller
		
escrita90:	subi $sp, $sp, 4	# espaço para 1 item na pilha
		sw $ra, ($sp)		# salva o retorno para a main
		move $a3, $a0		# aux = endereço base de matriz[i][j]
		
		la $a0, saida90		# carrega o endereço da string
		li $v0, 4		# código de impressão de string
		syscall			# imprime a string
		
		li $t0, 2		# i = 2
		li $t1, 0		# j = 0
		
e90: 		jal indice		# calcula o endereço de matriz[i][j]
		lw $a0, ($v0)		# valor em matriz[i][j]
		
		li $v0, 1		# código de impressão de inteiro
		syscall			# imprime o inteiro
		
		la $a0, 32		# código ASCII para impressão de espaço
		li $v0, 11		# código para impressão de caractere
		syscall			# imprime o caractere (espaço)
		
		subi $t0, $t0, 1	# i--
		
		bge $t0, $zero, e90	# if (i >= 0) goto e90
		
		la $a0, 10		# código ASCII para impressão de quebra de linha (\n)
		syscall			# imprime o caractere (quebra de linha)
		
		li $t0, 2		# i = 2
		
		addi $t1, $t1, 1	# j++
		
		blt $t1, $a2, e90	# if (i < numeroLinhas) goto e90
		
		li $t0, 0		# i = 0
		li $t1, 0		# j = 0
		
		lw $ra, ($sp)		# recupera o retorno para main
		addi $sp, $sp, 4	# libera espaço na pilha
		move $v0, $a3		# endereço base da matriz para retorno
		jr $ra			# retorna para o caller
		
escrita180:	subi $sp, $sp, 4	# espaço para 1 item na pilha
		sw $ra, ($sp)		# salva o retorno para a main
		move $a3, $a0		# aux = endereço base de matriz[i][j]
		
		la $a0, saida180	# carrega o endereço da string
		li $v0, 4		# código de impressão de string
		syscall			# imprime a string
		
		li $t0, 2		# i = 2
		li $t1, 2		# j = 2
		
e180: 		jal indice		# calcula o endereço de matriz[i][j]
		lw $a0, ($v0)		# valor em matriz[i][j]
		
		li $v0, 1		# código de impressão de inteiro
		syscall			# imprime o inteiro
		
		la $a0, 32		# código ASCII para impressão de espaço
		li $v0, 11		# código para impressão de caractere
		syscall			# imprime o caractere (espaço)
		
		subi $t1, $t1, 1	# j--
		
		bge $t1, $zero, e180	# if (j >= 0) goto e180
		
		la $a0, 10		# código ASCII para impressão de quebra de linha (\n)
		syscall			# imprime o caractere (quebra de linha)
		
		li $t1, 2		# j = 2
		
		subi $t0, $t0, 1	# i--
		
		bge $t0, $zero, e180	# if (i >= 0) goto e180
		
		li $t0, 0		# i = 0
		li $t1, 0		# j = 0
		
		lw $ra, ($sp)		# recupera o retorno para main
		addi $sp, $sp, 4	# libera espaço na pilha
		move $v0, $a3		# endereço base da matriz para retorno
		jr $ra			# retorna para o caller
		
escrita270:	subi $sp, $sp, 4	# espaço para 1 item na pilha
		sw $ra, ($sp)		# salva o retorno para a main
		move $a3, $a0		# aux = endereço base de matriz[i][j]
		
		la $a0, saida180	# carrega o endereço da string
		li $v0, 4		# código de impressão de string
		syscall			# imprime a string
		
		li $t0, 0		# i = 0
		li $t1, 2		# j = 2
		
e270: 		jal indice		# calcula o endereço de matriz[i][j]
		lw $a0, ($v0)		# valor em matriz[i][j]
		
		li $v0, 1		# código de impressão de inteiro
		syscall			# imprime o inteiro
		
		la $a0, 32		# código ASCII para impressão de espaço
		li $v0, 11		# código para impressão de caractere
		syscall			# imprime o caractere (espaço)
		
		addi $t0, $t0, 1	# i++
		
		blt $t0, $a1, e270	# if (i < numeroLinhas) goto e270
		
		la $a0, 10		# código ASCII para impressão de quebra de linha (\n)
		syscall			# imprime o caractere (quebra de linha)
		
		li $t0, 0		# i = 0
		
		subi $t1, $t1, 1	# j--
		
		bge $t1, $zero, e270	# if (j >= 0) goto e270
		
		li $t0, 0		# i = 0
		li $t1, 0		# j = 0
		
		lw $ra, ($sp)		# recupera o retorno para main
		addi $sp, $sp, 4	# libera espaço na pilha
		move $v0, $a3		# endereço base da matriz para retorno
		jr $ra			# retorna para o callers
		
saida:		li $v0, 10		# código para finalizar o programa
		syscall			# finaliza o programa
