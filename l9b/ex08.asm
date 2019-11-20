.data

entradaN: 	.asciiz "Numero inteiro n: "
entradaP: 	.asciiz "Numero inteiro p: "
saida:		.asciiz "Anp = "

.text

main:		la $a0, entradaN	# carrega o endereço da string
		li $v0, 4		# código de impressão de string
		syscall			# imprime a string
		
		li $v0, 5		# codigo de leitura de inteiro
		syscall			# leitura do valor (retorna em $v0)
		
		move $t0, $v0		# aux $t0 = n
		
		la $a0, entradaP	# carrega o endereço da string
		li $v0, 4		# código de impressão de string
		syscall			# imprime a string
		
		li $v0, 5		# codigo de leitura de inteiro
		syscall			# leitura do valor (retorna em $v0)
		
		move $a0, $t0		# parametro $a0 = n
		move $a1, $v0		# parametro $a1 = p
		
		jal permutar		# permutar(x, y), retorna o numero de arranjos de n elementos p a p
		
		move $a0, $v0		# parametro $a0 recebe o retorno $v0
		
		jal imprimir		# imprimir(resultado), imprime o resultado da permutacao
		
		j finalizar		# finaliza o programa
		
permutar:	sw $ra, ($sp)		# salva o retorno para a main

		bgt $a1, $a0, falsoP	# se p > n, retorna -1

		jal fatorial		# fatorial(n), retorna n!
		
		move $s0, $v0		# $s0 recebe n!
		
		sub $a0, $a0, $a1 	# parametro $a0 recebe n - p

		jal fatorial		# fatorial(n-p), retorna (n-p)!
		
		move $s1, $v0		# $s1 recebe (n-p)!
		
		div $v0, $s0, $s1	# retorno $v0 recebe n! / (n-p)!

		lw $ra, ($sp)		# recupera o retorno para a main
		jr $ra			# retorna para o caller
		
falsoP:		li $v0, -1		# retorna -1
		lw $ra, ($sp)		# recupera o retorno para a main
		jr $ra			# retorna para o caller
		
fatorial:	move $t0, $a0		# aux $t0 recebe parametro $a0
		li $v0, 0		# retorno $v0 recebe 0
		
		subi $t0, $t0, 1	# aux--
		mul $v0, $a0, $t0	# retorno = parametro $a0 * (parametro $a0 - 1)
		
f:		subi $t0, $t0, 1	# aux--
		
		beq $t0, 0, fimF	# se aux = 0, retorna
		
		mul $v0, $v0, $t0	# retorno * aux
		
		j f			# loop
		
fimF:		jr $ra			# retorna para o caller

imprimir:	move $t0, $a0		# aux $t0 recebe o parametro $a0 (resultado)

		la $a0, saida		# carrega o endereço da string
		li $v0, 4		# código de impressão de string
		syscall			# imprime a string

		move $a0, $t0		# valor de $t0 (resultado) para impressao
		li $v0, 1		# código de impressao de inteiro
		syscall			# imprime resultado
		
		jr $ra			# retorna para o caller
		
finalizar:	li $v0, 10		# código para finalizar o programa
		syscall			# finaliza o programa
