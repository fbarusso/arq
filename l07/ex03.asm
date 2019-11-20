.data
linhasMatriz: .asciiz "Linhas: "
colunasMatriz: .asciiz "Colunas: "
entradaMatriz: .asciiz "Insira o valor de matriz["
entradaMatriz2: .asciiz "]["
entradaMatriz3: .asciiz "]: "
resultadoLinhas: .asciiz "Numero de linhas nulas: "
resultadoColunas: .asciiz "Numero de colunas nulas: "
quebraDeLinha: .asciiz "\n"

.text
	
main:	la $a0, linhasMatriz	# carrega o endereço da string
	li $v0, 4		# código de impressão de string
	syscall			# imprime a string
	
	li $v0, 5		# codigo de leitura de inteiro
	syscall			# leitura do valor (retorna em $v0)
	
	move $a1, $v0		# número de linhas recebe $v0
	
	la $a0, colunasMatriz	# carrega o endereço da string
	li $v0, 4		# código de impressão de string
	syscall			# imprime a string
	
	li $v0, 5		# codigo de leitura de inteiro
	syscall			# leitura do valor (retorna em $v0)
	
	move $a2, $v0		# número de colunas recebe $v0
	
	mul $t0, $a1, $a2	# $t0 = linhas * colunas
	
	mul $a0, $t0, 4		# $a0 = tamanho da matriz * 4
	li $v0, 9		# código de alocação dinamica
	syscall			# aloca tamanho * 4 bytes (endereço em $v0)
	
	li $t0, 0		# $t0 = 0
	
	la $a0, ($v0)		# $a0 aponta para $v0 (local onde a matriz esta alocada)
	
	jal leitura		# leitura (matriz, numeroLinhas, numeroColunas) retorna matriz em $v0
	
	move $a0, $v0		# move o endereço da matriz para argumento $a0
	
	jal percorreLinhas	# percorreLinhas(matriz, numeroLinhas, numeroColunas)
	
	move $a0, $v0		# move o endereço da matriz para argumento $a0
	
	jal percorreColunas	# percorreColunas(matriz, numeroLinhas, numeroColunas)
	
	jal imprimeResultado	# imprime numero de linhas e colunas
	
	li $v0, 10		# código para finalizar o programa
	syscall			# finaliza o programa

indice:	mul $v0, $t0, $a2	# i * numeroColunas
	add $v0, $v0, $t1	# (i * numeroColunas) + j
	sll $v0, $v0, 2		# [(i * numeroColunas) + j] * 4 (inteiro)
	add $v0, $v0, $a3	# soma o endereço base de matriz
	jr $ra			# retorna para o caller

leitura:subi $sp, $sp, 4	# espaço para 1 item na pilha
	sw $ra, ($sp)		# salva o retorno para a main
	move $a3, $a0		# aux = endereço base de matriz
	li $s1, 0		# contadorLinhasNulas = 0
	
l:	la $a0, entradaMatriz	# carrega o endereço da string
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
	blt $t1, $a2, l		# if (j < numeroColunas1) goto 1
	li $t1, 0		# j = 0
	
	addi $t0, $t0, 1	# i++
	blt $t0, $a1, l		# if (i < numeroLinhas) goto 1
	li $t0, 0		# i = 0
	
	lw $ra, ($sp)		# recupera o retorno para a main
	addi $sp, $sp, 4	# libera o espaço na pilha
	move $v0, $a3		# endereço da matriz para retorno
	jr $ra

percorreLinhas:
	subi $sp, $sp, 4	# espaço para 1 item na pilha
	sw $ra, ($sp)		# salva o retorno para a main
	move $a3, $a0		# aux = endereço base de matriz
	li $s0, 0		# soma = 0
	li $t7, 0		# variavel intermediaria = 0
	li $s1, 0		# contadorLinhasNulas = 0
	
pL:	jal indice		# calcula o endereço de matriz[i][j]

	lw $t7, ($v0)		# t7 = valor de matriz[i][j]
	
	add $s0, $s0, $t7	# soma = soma + valor em matriz[i][j]
	
	addi, $t1, $t1, 1	# j++
	
	blt $t1, $a2, pL	# if (j < numeroColunas) goto pL
	
	bne $s0, 0, continueLinhas
	
	add $s1, $s1, 1		# contadorLinhasNulas++
	
continueLinhas:
	
	li $s0, 0		# soma = 0
	
	li $t1, 0		# j = 0
	
	addi $t0, $t0, 1	# i++
	
	blt $t0, $a1, pL	# if (i < numeroLinhas) goto pL
	
	li $t0, 0		# i = 0
	
	lw $ra, ($sp)		# recupera o endereço de retorno pra main
	addi $sp, $sp, 4	# libera espaço na pilha
	move $v0, $a3		# endereço base da matriz para retorno
	jr $ra 			#retorna para a main
	
percorreColunas:
	subi $sp, $sp, 4	# espaço para 1 item na pilha
	sw $ra, ($sp)		# salva o retorno para a main
	move $a3, $a0		# aux = endereço base de matriz
	li $s0, 0		# soma = 0
	li $t7, 0		# variavel intermediaria = 0
	li $s2, 0		# contadorColunasNulas = 0
	
pC:	jal indice		# calcula o endereço de matriz[i][j]

	lw $t7, ($v0)		# t7 = valor de matriz[i][j]
	
	add $s0, $s0, $t7	# soma = soma + valor em matriz[i][j]
	
	addi, $t0, $t0, 1	# i++
	
	blt $t0, $a1, pC	# if (i < numeroLinhas) goto pL
	
	bne $s0, 0, continueColunas
	
	add $s2, $s2, 1		# contadorColunasNulas++
	
continueColunas:
	
	li $s0, 0		# soma = 0
	
	li $t0, 0		# i = 0
	
	addi $t1, $t1, 1	# j++
	
	blt $t1, $a2, pC	# if (j < numeroColunas) goto pL
	
	li $t1, 0		# j = 0
	
	lw $ra, ($sp)		# recupera o endereço de retorno pra main
	addi $sp, $sp, 4	# libera espaço na pilha
	move $v0, $a3		# endereço base da matriz para retorno
	jr $ra 			#retorna para a main
	
imprimeResultado:
	la $a0, resultadoLinhas	# carrega o endereço da string
	li $v0, 4		# código de impressão de string
	syscall			# imprime a string
	
	move $a0, $s1		# valor de s1 para impressao
	li $v0, 1		# código de impressao de inteiro
	syscall			# imprime i
	
	la $a0, quebraDeLinha	# carrega o endereço da string
	li $v0, 4		# código de impressão de string
	syscall			# imprime a
	
	la $a0, resultadoColunas# carrega o endereço da string
	li $v0, 4		# código de impressão de string
	syscall			# imprime a string
	
	move $a0, $s2		# valor de s2 para impressao
	li $v0, 1		# código de impressao de inteiro
	syscall			# imprime i
	
	jr $ra			# volta para main
	
	
	
