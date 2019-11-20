.data
strLinhas: .asciiz "Forneca o numero de linhas da matriz: "
strColunas: .asciiz "Forneca o numero de colunas da matriz: "
strEntradaMatriz: .asciiz "Insira o valor M["
strEntradaMatriz2: .asciiz "]["
strEntradaMatriz3: .asciiz "]:"
quebraLinha: .asciiz "\n"
espaco: .asciiz " "
strMatriz: .asciiz "Matriz inserida:\n"
somaPrimos: .asciiz "Soma de todos os numeros primos: "
strMatrizImpares: .asciiz "Matriz com as linhas impares trocadas: \n"

.text
main:
	la $a0, strLinhas
	li $v0, 4		#Codigo de impressao de string
	syscall
	
	li $v0, 5		#Codigo de leitura de inteiro
	syscall
	move $s1, $v0		#$s1 armazena o numero de linhas
	
	la $a0, strColunas
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $s2, $v0		#$s2 armazena o numero de colunas
	
	mul $t0, $s1, $s2	#$t0 armazena o numero de elementos da matriz
	
	mul $a0, $t0, 4		#Passa para o parametro a quantidade de memoria necessaria para o tamanho da matriz
	li $v0, 9		#Codigo para alocacao dinamica
	syscall			#Retorna o endereco base da matriz em $v0
	
	move $s0, $v0		#Armazena o endereco base da matriz em $s0
	
	jal lerMatriz
	
	la $a0, quebraLinha
	li $v0, 4
	syscall
	
	la $a0, strMatriz
	li $v0, 4
	syscall
	
	move $a0, $s0		#Passa o endereco base da matriz 1 para o parametro
	jal imprimirMatriz
	
	mul $t0, $s1, $s2	#$t0 armazena o numero de elementos da matriz
	
	mul $a0, $t0, 4		#Passa para o parametro a quantidade de memoria necessaria para o tamanho da matriz
	li $v0, 9		#Codigo para alocacao dinamica
	syscall			#Retorna o endereco base da matriz em $v0
	
	move $s4, $v0		#Passa o endereco base da matriz 2 para $s4
	
	jal trocarImpares
	
	la $a0, strMatrizImpares
	li $v0, 4
	syscall

	move $a0, $s4		#Passa o endereco base da matriz 2 para o parametro
	jal imprimirMatriz
	
	jal percorrerPrimos	#Retorna a soma de numeros primos da matriz
	move $s3, $v0		#Armazena a soma retornada da funcao em $s3
	
	la $a0, quebraLinha
	li $v0, 4
	syscall
	
	la $a0, somaPrimos
	li $v0, 4
	syscall
	
	move $a0, $s3
	li $v0, 1
	syscall
	
	la $a0, quebraLinha
	li $v0, 4
	syscall
	li $v0, 10		#Codigo para finalizacao do programa
	syscall

indice:
	mul $v0, $a0, $s2	#i * numero de Colunas
	add $v0, $v0, $a1	#(i * numero de Colunas) + j
	sll $v0, $v0, 2		#[(i * numeroColunas) + j] * 4
	add $v0, $v0, $a2	#Soma ao endereco base da matriz
	
	jr $ra

lerMatriz:
	subi $sp, $sp, 4	#Espaco para 1 item na pilha
	sw $ra, ($sp)		#Salva o retorno para a main
	
	li $t0, 0		#Reseta o contador i
	li $t1, 0		#Reseta o contador j
	
lL:	la $a0, strEntradaMatriz
	li $v0, 4
	syscall
	
	move $a0, $t0
	li $v0, 1		#Codigo para impressao de inteiros
	syscall
	
	la $a0, strEntradaMatriz2
	li $v0, 4
	syscall
	
	move $a0, $t1
	li $v0, 1
	syscall
	
	la $a0, strEntradaMatriz3
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $t2, $v0		#t2 recebe o valor lido
	
	move $a0, $t0		#Passa o contador i para o parametro
	move $a1, $t1		#Passa o contador i para o parametro
	move $a2, $s0		#Passa o endereco base da matriz para o parametro
	jal indice
	
	sw $t2, ($v0)		#Armazena o conteudo lido ao endereco da matriz (calculado em 'indice')
	
	addi $t1, $t1, 1	#Incrementa o contador j
	blt $t1, $s2, lL	#Loop caso j < numero de Colunas
	li $t1, 0		#Reseta o contador j
	
	addi $t0, $t0, 1	#Incrementa o contador i
	blt $t0, $s1, lL	#Loop caso i < numero de Linhas
	
	lw $ra, ($sp)		#Recupera o retorno para a main
	addi $sp, $sp, 4	#Libera espaco na pilha
	
	jr $ra
	
imprimirMatriz:
	subi $sp, $sp, 4	#Espaco para 1 item na pilha
	sw $ra, ($sp)		#Salva o retorno para a main
	
	move $t5, $a0		#Passa o endereco base da matriz para $t5
	li $t0, 0		#Reseta o contador i
	li $t1, 0		#Reseta o contador j
	
lI:	move $a0, $t0		#Passa o contador i para o parametro
	move $a1, $t1		#Passa o contador j para o parametro
	move $a2, $t5		#Passa o endereco base da matriz para o parametro
	jal indice
	
	lw $a0, ($v0)		#Armazena em $a0 o conteudo contido no endereco salvo por $v0
	li $v0, 1
	syscall
	
	la $a0, espaco
	li $v0, 4
	syscall
	
	addi $t1, $t1, 1	#Incrementa o contador j
	blt $t1, $s2, lI	#Loop caso o contador j < numero de Colunas
	li $t1, 0		#Reseta o contador j
	
	la $a0, quebraLinha
	li $v0, 4
	syscall
	
	addi $t0, $t0, 1	#Incrementa o contador i
	blt $t0, $s1, lI	#Loop caso o contador i < numero de Linhas
	
	lw $ra, ($sp)		#Recupera o retorno para a main
	addi $sp, $sp, 4	#Libera espaco na pilha
	
	jr $ra

percorrerPrimos:
	subi $sp, $sp, 4	#Espaco para 1 item na pilha
	sw $ra, ($sp)		#Salva o retorno para a main
	
	li $t0, 0		#Reseta o contador i
	li $t1, 0		#Reseta o contador j
	li $t5, 0		#Reseta a soma de primos
	
lPcrr:	move $a0, $t0
	move $a1, $t1
	move $a2, $s0
	jal indice
	
	lw $a0, ($v0)		#Armazena em $a0 o conteudo contido no endereco salvo por $v0
	
	jal testPrime		#Verifica se o numero e primo
	
	addi $t1, $t1, 1	#Incrementa o contador j
	blt $t1, $s2, lPcrr	#Loop caso o contador j < numero de Colunas
	li $t1, 0		#Reseta o contador j
	
	addi $t0, $t0, 1	#Incrementa o contador i
	blt $t0, $s1, lPcrr	#Loop caso o contador i < numero de Linhas
	
	lw $ra, ($sp)		#Recupera o retorno para a main
	addi $sp, $sp, 4	#Libera espaco na pilha
	
	move $v0, $t5
	jr $ra
	
testPrime:
	beq $a0, 1, notPrime	# if $a0 == 1 then notPrime()
	beq $a0, 2, prime	# if $a0 == 2 then prime ()
	
	li $t3, 2		#Contador para os primos
	
lPrime:	div $a0, $t3			# num / i
	mfhi $t4			# move o resto para $t4
	
	beq, $t4, $zero, notPrime	# if num % i == 0 then notPrime ()
	
	addi $t3, $t3, 1 		# i++
	blt $t3, $a0, lPrime		# if i < num vai para prime ()

	j prime				# vai para prime ()
	
	
prime:
	add $t5, $t5, $a0	#Adiciona o numero a soma de primos
	jr $ra
	
notPrime:
	jr $ra
	
trocarImpares:
	subi $sp, $sp, 4	#Espaco para 1 item na pilha
	sw $ra, ($sp)		#Salva o retorno para a main

	li $s5, 1		#Registrador de verificacao
	li $t0, 0		#Reseta o contador i
	li $t1, 0		#Reseta o contador j
	li $t9, 2		#Constante 2

loop:	addi $t3, $t0, 1	#Linha da matriz
	div $t3, $t9		#Divide i + 1 por 2
	mfhi $t4		#Salva o resto da divisao em $t4
	beq $t4, 0, par
	
	bne $s5, 1, p0		#p0 -> primeiro é 0
	subi $t6, $s1, 2	#Pega a penultima linha
	bge $t0, $t6, p0
	addi $t6, $t0, 2	#Pega a linha impar sequente a linha i
	
	move $a0, $t6
	move $a1, $t1
	move $a2, $s0
	jal indice
	
	lw $t5, ($v0)		#Armazena em $t5 o conteudo da matriz 1
	
	move $a0, $t0
	move $a1, $t1
	move $a2, $s4
	jal indice
	
	sw $t5, ($v0)		#Armazena na matriz 2 o conteudo da matriz 1
	
	subi $t7, $s2, 1	#Pega o ultimo index de coluna
	bne $t1, $t7, j1
	li $s5, 0		#primeiro = 0;
	
j1:	j fL
	
p0:	bne $s5, 0, par
	subi $t6, $t0, 2	#Pega a linha impar anterior a linha i
	
	move $a0, $t6
	move $a1, $t1
	move $a2, $s0
	jal indice
	
	lw $t5, ($v0)		#Armazena em $t5 o conteudo da matriz 1
	
	move $a0, $t0
	move $a1, $t1
	move $a2, $s4
	jal indice
	
	sw $t5, ($v0)		#Armazena na matriz 2 o conteudo da matriz 1
	
	subi $t7, $s2, 1	#Pega o ultimo index de coluna
	bne $t1, $t7, j2
	li $s5, 1		#primeiro = 1;
	
j2:	j fL			#fL -> final loop
	
par:	move $a0, $t0
	move $a1, $t1
	move $a2, $s0
	jal indice

	lw $t5, ($v0)		#Armazena em $t5 o conteudo da matriz 1
	
	move $a0, $t0
	move $a1, $t1
	move $a2, $s4
	jal indice
	
	sw $t5, ($v0)		#Armazena na matriz 2 o conteudo da matriz 1
	
fL:	addi $t1, $t1, 1	#Incrementa o contador j
	blt $t1, $s2, loop
	li $t1, 0		#Reseta o contador j
	
	addi $t0, $t0, 1	#Incrementa o contador i
	blt $t0, $s1, loop
	
	lw $ra, ($sp)		#Recupera o retorno para a main
	addi $sp, $sp, 4	#Libera espaco na pilha
	
	jr $ra
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	